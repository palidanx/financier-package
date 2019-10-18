angular.module('financier').directive('applyUpdate', offline => {
  let show = false;

  function controller($scope) {
    this.show = show;

    $scope.$on('serviceWorker:updateReady', () => {
      offline.applyUpdate();
    });

    $scope.$on('serviceWorker:updated', () => {
      show = true;
      this.show = true;

      $scope.$apply();
    });

    this.close = () => {
      this.show = false;
      show = false;
    };

    this.applyUpdate = () => {
      window.location.reload(true);
    };
  }

  return {
    restrict: 'E',
    template: require('./applyUpdate.html'),
    controller,
    replace: true,
    controllerAs: 'applyUpdateCtrl'
  };
});
