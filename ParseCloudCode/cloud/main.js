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

function saveSearchItem(searchableObject, searchableObjectClassName, searchableObjectSearchableAttributes) {

	// Set up SearchItem query
	var SearchItem = Parse.Object.extend("SearchItem");
	var query = new Parse.Query(SearchItem);
	query.equalTo(searchableObjectClassName.toLowerCase(), searchableObject);

	// Execute SearchItem query
	console.log("Querying for existing SearchItem");
	query.first({
		success: function(searchItem) {

			if (searchItem === undefined) {
				console.log("Existing SearchItem not found");
				// Create searchItem
				searchItem = new SearchItem();
				// Link searchItem to object
				searchItem.set(searchableObjectClassName.toLowerCase(), searchableObject);
			} else {
				console.log("Existing SearchItem found - " + searchItem);
			}

			// Set up searchText
			var searchText = "";
			for (var i=0; i<searchableObjectSearchableAttributes.length; i++) {
				var searchableAttribute = searchableObjectSearchableAttributes[i];
				console.log("Adding searchableAttribute " + searchableAttribute + " : " + searchableObject.get(searchableAttribute) + " to searchable text");
				searchText = searchText + " " + searchableObject.get(searchableAttribute);
			}
			
			// Save searchItem with updated searchText
			console.log("Saving SearchItem with searchable text " + searchText);
			searchItem.save({
				text: searchText
			}, {
				success: function(searchItem) {
					console.log("SearchItem saved - " + searchItem);
				},
				error: function(searchItem, error) {
					throw "Error saving SearchItem for " + searchableObjectClassName + " with id " + searchableObject.id + " while saving matching SearchItem - [" + error.code + " : " + error.message + "]";
				}
			});

		},
		error: function(error) {
			throw "Error saving SearchItem for " + searchableObjectClassName + " with id " + searchableObject.id + " while looking for matching SearchItem - [" + error.code + " : " + error.message + "]";
		}
	});

}

// Artist
// Searchable text should include "name", "bio", "statement"
Parse.Cloud.afterSave("Artist", function(request) {
	saveSearchItem(request.object, "Artist", ["name", "bio", "statement"]);
});

// Project
// Searchable text should include "title", "description"
Parse.Cloud.afterSave("Project", function(request) {
	saveSearchItem(request.object, "Project", ["title", "description"]);
});
