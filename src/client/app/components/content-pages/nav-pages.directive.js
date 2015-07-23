(function() {
  'use strict';

  angular.module('app.components')
    .directive('navPages', NavPagesDirective);

  /** @ngInject */
  function NavPagesDirective() {
    var directive = {
      restrict: 'AE',
      scope: {
        item: '='
      },
      link: link,
      templateUrl: 'app/components/content-pages/nav-pages.html',
      controller: NavPagesController,
      controllerAs: 'vm',
      bindToController: true
    };

    return directive;

    function link(scope, element, attrs, vm, transclude) {
      vm.activate();
    }

    /** @ngInject */
    function NavPagesController($state, $q, ContentPage, lodash) {
      var vm = this;

      // METHODS
      vm.isActive = isActive;
      vm.activate = activate;

      function activate() {
        updatePageList();
        console.log(vm);
      }

      function isActive() {
        return $state.includes(vm.item.state);
      }

      // Private

      function updatePageList() {
        $q.when(ContentPage.query()).then(handleResults);

        function handleResults(pages) {
          vm.pages = pages;
        }
      }
    }
  }
})();
