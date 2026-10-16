const admin = require("firebase-admin/app");
admin.initializeApp();

const getCoordinates = require("./get_coordinates.js");
exports.getCoordinates = getCoordinates.getCoordinates;
