(function() {
  'use strict';

  angular.module('app.states')
    .run(appRun);

  /** @ngInject */
  function appRun(routerHelper, navigationHelper) {
    routerHelper.configureStates(getStates());
    navigationHelper.navItems(navItems());
    navigationHelper.sidebarItems(sidebarItems());
  }

  function getStates() {
    return {
      'admin.users.edit': {
        url: '/edit/:id',
        templateUrl: 'app/states/admin/users/edit/edit.html',
        controller: StateController,
        controllerAs: 'vm',
        title: 'Admin User Edit',
        resolve: {
          userToEdit: resolveUser
        }
      }
    };
  }

  function navItems() {
    return {};
  }

  function sidebarItems() {
    return {};
  }

  /** @ngInject */
  function resolveUser(Staff, $stateParams) {
    if ($stateParams.id) {
      return Staff.get({id: $stateParams.id}).$promise;
    } else {
      return {};
    }
  }

  /** @ngInject */
  function StateController($stateParams, logger, userToEdit) {
    var vm = this;

    vm.title = 'Admin User Edit';
    vm.activate = activate;
    vm.userToEdit = userToEdit;

    activate();

    function activate() {
      logger.info('Activated Admin User Modification');
    }
  }
})();
