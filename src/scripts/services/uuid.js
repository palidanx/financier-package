import uuid from 'node-uuid';

// por que no?

angular.module('financier').factory('uuid', function () {
  return uuid.v4;
});
