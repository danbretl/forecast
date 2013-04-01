// setFavorite
// - check that isFavorite, user, objectClass, and objectID have all been specified
// - find any existing Favorite object with specified user and (artist or project)
// - if matching Favorite object did not exist, create one
// - set isFavorite on Favorite object
Parse.Cloud.define("setFavorite", function(request, response) {
	if (!(request.user === undefined ||
		  request.params.isFavorite === undefined ||
		  request.params.objectClass === undefined ||
		  request.params.objectID === undefined)) {
	
		// Set up object to favorite
		console.log("Setting up object to favorite");
		var ObjectToFavoriteClass = Parse.Object.extend(request.params.objectClass);
		var objectToFavorite = new ObjectToFavoriteClass();
		objectToFavorite.id = request.params.objectID;
		
		// Set up Favorite object query
		console.log("Setting up query for favorite");
		var Favorite = Parse.Object.extend("Favorite");
		var query = new Parse.Query(Favorite);
		query.equalTo("user", request.user);
		query.equalTo(request.params.objectClass.toLowerCase(), objectToFavorite);
		
		// Execute query
		console.log("Querying for favorite");
		query.first({
			success: function(favorite) {
				if (favorite === undefined) {
					console.log("Favorite not found");
					// Create favorite
					favorite = new Favorite();
					// Link favorite to user and object
					favorite.set("user", request.user);
					favorite.set(request.params.objectClass.toLowerCase(), objectToFavorite);
				} else {
					console.log("Favorite found - " + favorite);
				}
				// Set favorite isFavorite value
				favorite.set("isFavorite", request.params.isFavorite);
				// Save created/updated favorite
				favorite.save(null, {
					success: function(favorite) {
						response.success(favorite);
					},
					error: function(favorite, error) {
						response.error("updating favorite - " + error.message);
					}
				});
			},
			error: function(error) {
				response.error("querying for favorite - " + error.message);
			}
		});
	} else {
		response.error("missing parameters");
	}
	
});

// Project
// - title
// - description
// Artist
// - name
// - bio
// - statement
Parse.Cloud.afterSave("Artist", function(request) {
//   query = new Parse.Query("SearchItem");
//   query.get(request.object.get("artist").id, {
//     success: function(searchItem) {
//       searchItem.text = 
//       post.increment("comments");
//       post.save();
//     },
//     error: function(error) {
//       throw "Got an error " + error.code + " : " + error.message;
//     }
//   });
});
