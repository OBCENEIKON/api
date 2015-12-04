require 'rack/contrib/post_body_content_type_parser'
# begin
#   require 'json'
# rescue LoadError => e
#   require 'json/pure'
# end
#
# module Rack
#   puts 'Rack'
#
#   # A Rack middleware for parsing POST/PUT body data when Content-Type is
#   # not one of the standard supported types, like <tt>application/json</tt>.
#   #
#   # TODO: Find a better name.
#   #
#   class PostBodyContentTypeParser
#     puts 'Rack::PostBodyContentTypeParser'
#
#     # Constants
#     #
#     CONTENT_TYPE = 'CONTENT_TYPE'.freeze
#     PARAMS = 'params'.freeze
#     POST_BODY = 'rack.input'.freeze
#     FORM_INPUT = 'rack.request.form_input'.freeze
#     FORM_HASH = 'rack.request.form_hash'.freeze
#     FORM_VARS = 'rack.request.form_vars'.freeze
#
#     # Supported Content-Types
#     #
#     APPLICATION_JSON = 'application/json'.freeze
#
#     def initialize(app)
#       @app = app
#     end
#
#     def call(env)
#       if Rack::Request.new(env).media_type == APPLICATION_JSON && (body = env[POST_BODY].read).length != 0
#         env[POST_BODY].rewind # somebody might try to read this stream
#         env.update(FORM_HASH: JSON.parse(body, create_additions: false), FORM_INPUT: env[POST_BODY], PARAMS: JSON.parse(body, create_additions: false), FORM_VARS: 'staff%5Bemail%5D=admin%40projectjellyfish.org&staff%5Bpassword%5D=jellyfish')
#       end
#       @app.call(env)
#     end
#
#   end
# end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :identity,
           model: Staff,
           fields: [:email],
           path_prefix: '/api/v1/staff/auth',
           # setup: ->(env) { Rack::Request::FORM_DATA_MEDIA_TYPES << 'application/json' },
           locate_conditions: ->(env) {
             # ap 'Lambda Request Params:'
             # ap request
             # ap request.params
             ap 'Lambda ENV'
             ap env
             json = env['RAW_POST_DATA'].to_json
             ap json
             # { model.auth_key => request.params['staff']['email'] }
           }
end

module OmniAuth
  module Strategies
    class Identity
      def request_phase
        if options[:on_login]
          options[:on_login].call(self.env)
        else
          OmniAuth::Form.build(
            :title => (options[:title] || "Identity Verification"),
            :url => callback_path
          ) do |f|
            f.text_field 'Login', 'staff[email]'
            f.password_field 'Password', 'staff[password]'
            f.html "<p align='center'><a href='#{registration_path}'>Create an Identity</a></p>"
          end.to_response
        end
      end

      def identity
        ap 'OmniAuth::Strategies::Identity.identity'
        ap 'Request Params'
        ap request.params
        ap 'Rack Input'
        ap env['rack.input'].read
        ap 'Rack Form Input'
        ap env['rack.request.form_input']
        ap 'Rack Form Hash'
        ap env['rack.request.form_hash']
        # if Rack::Mime.match?(request.media_type, 'application/json')
        #   post_body = env[POST_BODY].read
        #
        #   unless post_body.blank?
        #     begin
        #       new_form_hash = JSON.parse(post_body)
        #     rescue StandardError => error
        #       logger.warn "#{self.class} #{request.media_type} parsing error: #{error.to_s}" if respond_to? :logger
        #       return error_respon
        #     end
        #   end
        # else
        if options.locate_conditions.is_a? Proc
          # ap request['staff']['password']
          conditions = instance_exec(request, &options.locate_conditions)
          conditions.to_hash
        else
          conditions = options.locate_conditions.to_hash
        end
        ap conditions
        @identity ||= model.authenticate(conditions, request['staff']['password'] )
        # end
      end
    end
  end
end
