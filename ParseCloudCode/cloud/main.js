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
			searchText = searchText.toLowerCase();
			
			// Save searchItem with updated searchText
			console.log("Saving SearchItem with searchable text " + searchText);
			searchItem.set("text", searchText);
			if (searchableObjectClassName === "Project") {
				searchItem.set("categories", [searchableObject.get("category")]);
			}
			searchItem.save(null, {
				success: function(searchItem) {
					console.log("SearchItem saved - " + searchItem);
					var artist;
					var artistSearchItem;
					if (searchableObjectClassName === "Artist") {
						 artist = searchableObject;
						 artistSearchItem = searchItem;
					} else if (searchableObjectClassName === "Project") {
						artist = searchableObject.get("artist");
					}
					saveSearchItemCategoriesForArtist(artist, artistSearchItem);
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

function saveSearchItemCategoriesForArtist(artist, artistSearchItem) {
	console.log("saveSearchItemCategoriesForArtist : " + artist + " (" + artist.id + ")");
	var Project = Parse.Object.extend("Project");
	var query = new Parse.Query(Project);
	query.equalTo("artist", artist);
	query.include("category");
	query.find({
		success: function(projects) {
			var categories = new Array();
			for (var i=0; i<projects.length; i++) {
				var project = projects[i];
				categories.push(project.get("category"));
			}
			if (artistSearchItem !== undefined) {
				setArtistSearchItemCategories(artistSearchItem, categories);
			} else {
				var SearchItem = Parse.Object.extend("SearchItem");
				var query = new Parse.Query(SearchItem);
				query.equalTo("artist", artist);
				query.first({
					success: function(searchItem) {
						setArtistSearchItemCategories(searchItem, categories);
					},
					error: function(error) {
						throw "Error updating categories for Artist SearchItem while querying for search item - [" + error.code + " : " + error.message + "]";
					}
				});
			}
		},
		error: function(error) {
			throw "Error updating categories for Artist SearchItem while querying for projects for artist - [" + error.code + " : " + error.message + "]";
		}
	});
}

function setArtistSearchItemCategories(searchItem, categories) {
	searchItem.set("categories", categories);
	searchItem.save(null, {
		success: function(searchItem) {
			console.log("Updated categories for Artist SearchItem (now has " + searchItem.get("categories").length + " categories");
		},
		error: function(searchItem, error) {
			throw "Error updating categories for Artist SearchItem while saving search item - [" + error.code + " : " + error.message + "]";
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

function searchFor(term, categoryIDs, shouldSearchArtists, shouldSearchProjects, filterFavoriteArtists, filterFavoriteProjects, response) {

	var shouldFilterArtists  = !(filterFavoriteArtists  === undefined);
	var shouldFilterProjects = !(filterFavoriteProjects === undefined);
	shouldSearchArtists  = shouldSearchArtists  && (!shouldFilterArtists  || filterFavoriteArtists.length  > 0);
	shouldSearchProjects = shouldSearchProjects && (!shouldFilterProjects || filterFavoriteProjects.length > 0);
	var shouldSearchAll = shouldSearchArtists && shouldSearchProjects;

	var SearchItem = Parse.Object.extend("SearchItem");
	var querySearch;
	var querySearchArtist;
	var querySearchProject;

	if (shouldSearchArtists) {
		querySearchArtist = new Parse.Query(SearchItem);
		querySearchArtist.exists("artist");
		if (shouldFilterArtists) {
			querySearchArtist.containedIn("artist", filterFavoriteArtists);
		}
	}
	if (shouldSearchProjects) {
		querySearchProject = new Parse.Query(SearchItem);
		querySearchProject.exists("project");
		if (shouldFilterProjects) {
			querySearchProject.containedIn("project", filterFavoriteProjects);
		}
	}

	if (shouldSearchAll) {
		querySearch = Parse.Query.or(querySearchArtist, querySearchProject);
	} else {
		if (shouldSearchArtists) {
			querySearch = querySearchArtist;
		} else if (shouldSearchProjects) {
			querySearch = querySearchProject;
		}
	}

	if (!(term === undefined || term.length == 0)) {
		querySearch.contains("text", term);
	}

	if (!(categoryIDs === undefined || categoryIDs.length == 0)) {
		var categories = new Array();
		for (var i=0; i<categoryIDs.length; i++) {
			var Category = Parse.Object.extend("Category");
			var category = new Category();
			category.id = categoryIDs[i];
			categories.push(category);
		}
		querySearch.containedIn("categories", categories);
	}

	if (shouldSearchArtists) {
		querySearch.include("artist");
	}
	if (shouldSearchProjects) {
		querySearch.include("project");
	}

	querySearch.find({
		success: function(results) {
			response.success(results);
		},
		error: function(error) {
			response.error("querying for search items - [" + error.code + " : " + error.message + "]");
			throw "querying for search items - [" + error.code + " : " + error.message + "]";
		}
	});

}

Parse.Cloud.define("search", function(request, response) {
	if ((request.params.term === undefined || request.params.term.length < 3) &&
		(request.params.categoryIDs === undefined || request.params.categoryIDs.length == 0) &&
		(request.params.favoritesOnly === undefined || request.params.favoritesOnly == false)) {
		response.error("missing parameters");
	} else {
		var searchTerm = request.params.term.toLowerCase();

		var shouldSearchAll = (request.params.classes === undefined || request.params.classes.length == 0);
		var shouldSearchArtists  = shouldSearchAll || request.params.classes.indexOf("Artist")  != -1;
		var shouldSearchProjects = shouldSearchAll || request.params.classes.indexOf("Project") != -1;
		shouldSearchAll = shouldSearchArtists && shouldSearchProjects;

		var filterFavoriteArtists;
		var filterFavoriteProjects;

		if (request.user === undefined ||
			request.params.favoritesOnly === undefined ||
			request.params.favoritesOnly == false) {

			searchFor(searchTerm, request.params.categoryIDs, shouldSearchArtists, shouldSearchProjects, filterFavoriteArtists, filterFavoriteProjects, response);

		} else {

			filterFavoriteArtists  = new Array();
			filterFavoriteProjects = new Array();

			var Favorite = Parse.Object.extend("Favorite");
			var queryFavorite = new Parse.Query(Favorite);

			if (!shouldSearchAll) {
				if (shouldSearchArtists) {
					queryFavorite.exists("artist");
				} else if (shouldSearchProjects) {
					queryFavorite.exists("project");
				}
			}

			queryFavorite.equalTo("user", request.user);
			queryFavorite.equalTo("isFavorite", true);
			if (shouldSearchArtists) {
				queryFavorite.include("artist");
			}
			if (shouldSearchProjects) {
				queryFavorite.include("project");
			}

			queryFavorite.find({
				success: function(results) {
					if (results.length == 0) {
						response.success(results);
					} else {
						for (var i=0; i<results.length; i++) {
							var result = results[i];
							var favoriteArtist = result.get("artist");
							var favoriteProject = result.get("project");
							if (!(favoriteArtist === undefined)) {
								filterFavoriteArtists.push(favoriteArtist);
							} else if (!(favoriteProject === undefined)) {
								filterFavoriteProjects.push(favoriteProject);
							}
						}
						searchFor(searchTerm, request.params.categoryIDs, shouldSearchArtists, shouldSearchProjects, filterFavoriteArtists, filterFavoriteProjects, response);
					}
				},
				error: function(error) {
					response.error("querying for favorites - [" + error.code + " : " + error.message + "]");
				}
			});

		}
	}
});
