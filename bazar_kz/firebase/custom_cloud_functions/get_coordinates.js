const functions = require("firebase-functions");
const axios = require("axios");

exports.getCoordinates = functions.https.onCall(async (data, context) => {
  try {
    const { city, address } = data;

    if (!city || !address) {
      return { error: "Missing city or address" };
    }

    const query = encodeURIComponent(`${city}, ${address}`);

    const response = await axios.get(
      `https://nominatim.openstreetmap.org/search?q=${query}&format=json&limit=1`,
      {
        headers: {
          "User-Agent": "FlutterFlowApp/1.0 (your@email.com)",
          Accept: "application/json",
        },
      },
    );

    if (response.data.length === 0) {
      return { error: "No results found" };
    }

    const { lat, lon } = response.data[0];
    return {
      latitude: parseFloat(lat),
      longitude: parseFloat(lon),
    };
  } catch (error) {
    console.error("Geocoding error:", error.message);
    return { error: "Geocoding failed" };
  }
});
