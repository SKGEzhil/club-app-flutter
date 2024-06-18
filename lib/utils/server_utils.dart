
class ServerUtils {

  // static bool isInternetConnectionAvailable() {
  //   // Check internet connection
  //   final networkController = Get.find<NetworkController>();
  //   return networkController.isOnline.value;
  // }
  //
  // static Future<bool> verifyGoogleUser(email, token) async {
  //
  //   if(!isInternetConnectionAvailable()) {
  //     CustomGetSnackBar.show(message: "No Internet connection", color: Colors.red.withOpacity(0.5));
  //     throw Exception('No internet connection');
  //   }
  //
  //   print("Verifying google user...");
  //   const url = 'http://10.0.2.2:4000/googleVerification';
  //
  //   Map<String, String> headers = {
  //     'Content-Type': 'application/json',
  //     'Authorization': 'Bearer $token',
  //   };
  //
  //   final response = await http.post(
  //     Uri.parse(url),
  //     headers: headers,
  //   );
  //
  //   if (response.statusCode == 200) {
  //     print("POST request successful");
  //     print('Response: ${response.body}');
  //
  //     Map<String, dynamic> data = jsonDecode(response.body);
  //     SharedPrefs.saveToken(data['token']);
  //
  //     return await isUserExist(email);
  //
  //   } else {
  //     print("POST request failed");
  //     print('Response: ${response.body}');
  //     throw Exception('Failed to verify google user');
  //   }
  // }
  //
  // static Future<bool> isUserExist(email) async {
  //
  //   if(!isInternetConnectionAvailable()) {
  //     CustomGetSnackBar.show(message: "No Internet connection", color: Colors.red.withOpacity(0.5));
  //     throw Exception('No internet connection');
  //   }
  //
  //   print("Authenticating...");
  //   const url = 'http://10.0.2.2:4000/graphql';
  //
  //   final token = await SharedPrefs.getToken();
  //
  //   print('token: $token');
  //
  //   Map<String, String> headers = {
  //     'Content-Type': 'application/json',
  //     'Authorization': 'Bearer $token'
  //   };
  //
  //   final query = '''
  //     query {
  //       getUser(email: "$email") {
  //         id
  //         name
  //         email
  //         role
  //         photoUrl
  //       }
  //     }
  //   ''';
  //
  //   final response = await http.post(
  //     Uri.parse(url),
  //     headers: headers,
  //     body: jsonEncode({
  //       'query': query,
  //     }),
  //   );
  //
  //   if (response.statusCode == 200) {
  //     print("POST request successful");
  //     print('Response: ${response.body}');
  //
  //     Map<String, dynamic> data = jsonDecode(response.body);
  //     if (data['data']['getUser'] != null) {
  //       return true;
  //     } else {
  //       return false;
  //     }
  //   } else {
  //     print("POST request failed");
  //     print('Response: ${response.body}');
  //     throw Exception('Failed to authenticate user');
  //   }
  // }
  //
  // static Future<UserModel> getUserDetails(email) async {
  //
  //   if(!isInternetConnectionAvailable()) {
  //     CustomGetSnackBar.show(message: "No Internet connection", color: Colors.red.withOpacity(0.5));
  //     throw Exception('No internet connection');
  //   }
  //
  //   print("Fetching User...");
  //   const url = 'http://10.0.2.2:4000/graphql';
  //
  //   final token = await SharedPrefs.getToken();
  //
  //   print('token: $token');
  //
  //   Map<String, String> headers = {
  //     'Content-Type': 'application/json',
  //     'Authorization': 'Bearer $token'
  //   };
  //
  //   final query = '''
  //     query {
  //       getUser(email: "$email") {
  //         id
  //         name
  //         email
  //         role
  //         photoUrl
  //       }
  //     }
  //   ''';
  //
  //   final response = await http.post(
  //     Uri.parse(url),
  //     headers: headers,
  //     body: jsonEncode({
  //       'query': query,
  //     }),
  //   );
  //
  //   if (response.statusCode == 200) {
  //     print("POST request successful");
  //     print('Response: ${response.body}');
  //
  //     Map<String, dynamic> data = jsonDecode(response.body);
  //     final user = UserModel.fromJson(data['data']['getUser']);
  //     return user;
  //   } else {
  //     print("POST request failed");
  //     print('Response: ${response.body}');
  //     throw Exception('Failed to authenticate user');
  //   }
  // }
  //
  // static Future<UserModel> createUser(name, email, photoUrl) async {
  //
  //   if(!isInternetConnectionAvailable()) {
  //     CustomGetSnackBar.show(message: "No Internet connection", color: Colors.red.withOpacity(0.5));
  //     throw Exception('No internet connection');
  //   }
  //
  //   print("Fetching User...");
  //   const url = 'http://10.0.2.2:4000/graphql';
  //
  //   final token = await SharedPrefs.getToken();
  //
  //   print('token: $token');
  //
  //   Map<String, String> headers = {
  //     'Content-Type': 'application/json',
  //     'Authorization': 'Bearer $token'
  //   };
  //
  //   final query = '''
  //     mutation {
  //       createUser(name: "$name", email: "$email", photoUrl: "$photoUrl") {
  //        id
  //        name
  //        email
  //        role
  //        photoUrl
  //     }
  //   }
  //   ''';
  //
  //   final response = await http.post(
  //     Uri.parse(url),
  //     headers: headers,
  //     body: jsonEncode({
  //       'query': query,
  //     }),
  //   );
  //
  //   if (response.statusCode == 200) {
  //     print("POST request successful");
  //     print('Response: ${response.body}');
  //
  //     Map<String, dynamic> data = jsonDecode(response.body);
  //     final user = UserModel.fromJson(data['data']['createUser']);
  //     return user;
  //   } else {
  //     print("POST request failed");
  //     print('Response: ${response.body}');
  //     throw Exception('Failed to authenticate user');
  //   }
  // }
  //
  // static Future<List<Club>> fetchClubs() async {
  //
  //   if(!isInternetConnectionAvailable()) {
  //     CustomGetSnackBar.show(message: "No Internet connection", color: Colors.red.withOpacity(0.5));
  //     throw Exception('No internet connection');
  //   }
  //
  //   print("Fetching clubs...");
  //   const url = 'http://10.0.2.2:4000/graphql';
  //
  //   final token = await SharedPrefs.getToken();
  //
  //   print('token: $token');
  //
  //   Map<String, String> headers = {
  //     'Content-Type': 'application/json',
  //     'Authorization': 'Bearer $token'
  //   };
  //
  //   const query = '''
  //     query {
  //       getClubs {
  //         id
  //         name
  //         description
  //         imageUrl
  //         createdBy {
  //           id
  //           name
  //           email
  //           role
  //           photoUrl
  //         }
  //         members {
  //           id
  //           name
  //           email
  //           role
  //           photoUrl
  //         }
  //       }
  //     }
  //   ''';
  //
  //   final response = await http.post(
  //     Uri.parse(url),
  //     headers: headers,
  //     body: jsonEncode({
  //       'query': query,
  //     }),
  //   );
  //   if (response.statusCode == 200) {
  //     print("POST request successful");
  //     print('Response: ${response.body}');
  //     Map<String, dynamic> data = jsonDecode(response.body);
  //     final clubs = (data['data'])['getClubs'];
  //     final clubList = clubs.map<Club>((club) => Club.fromJson(club)).toList();
  //     return clubList;
  //   } else {
  //     print("POST request failed");
  //     print('Response: ${response.body}');
  //     throw Exception('Failed to fetch clubs');
  //   }
  // }
  //
  // static Future<List<Post>> fetchPosts() async {
  //
  //   if(!isInternetConnectionAvailable()) {
  //     CustomGetSnackBar.show(message: "No Internet connection", color: Colors.red.withOpacity(0.5));
  //     throw Exception('No internet connection');
  //   }
  //
  //   print("Fetching posts...");
  //   const url = 'http://10.0.2.2:4000/graphql';
  //
  //   final token = await SharedPrefs.getToken();
  //
  //   print('token: $token');
  //
  //   Map<String, String> headers = {
  //     'Content-Type': 'application/json',
  //     'Authorization': 'Bearer $token'
  //   };
  //
  //   const query = '''
  //     query {
  //       getPosts {
  //         id
  //         content
  //         createdBy {
  //           id
  //           name
  //           email
  //           role
  //           photoUrl
  //         }
  //         dateCreated
  //         imageUrl
  //         club {
  //           id
  //           name
  //         }
  //       }
  //     }
  //   ''';
  //
  //   final response = await http.post(
  //     Uri.parse(url),
  //     headers: headers,
  //     body: jsonEncode({
  //       'query': query,
  //     }),
  //   );
  //   if (response.statusCode == 200) {
  //     print("POST request successful");
  //     print('Response: ${response.body}');
  //     Map<String, dynamic> data = jsonDecode(response.body);
  //     final posts = (data['data'])['getPosts'];
  //     final postList = posts.map<Post>((post) => Post.fromJson(post)).toList();
  //     return postList;
  //   } else {
  //     print("POST request failed");
  //     print('Response: ${response.body}');
  //     throw Exception('Failed to fetch posts');
  //   }
  // }
  //
  // static Future<Post> createPost(context, content, imageUrl, createdBy, dateCreated, club) async {
  //
  //   if(!isInternetConnectionAvailable()) {
  //     CustomGetSnackBar.show(message: "No Internet connection", color: Colors.red.withOpacity(0.5));
  //     throw Exception('No internet connection');
  //   }
  //
  //   print("Creating posts...");
  //   const url = 'http://10.0.2.2:4000/graphql';
  //
  //   final token = await SharedPrefs.getToken();
  //
  //   print('token: $token');
  //
  //   Map<String, String> headers = {
  //     'Content-Type': 'application/json',
  //     'Authorization': 'Bearer $token'
  //   };
  //
  //   final query = '''
  //     mutation {
  //       createPost(content: "$content", imageUrl: "$imageUrl", createdBy: "$createdBy", dateCreated: "$dateCreated", club: "$club") {
  //         id
  //         content
  //         imageUrl
  //         dateCreated
  //         createdBy {
  //           id
  //           name
  //           email
  //           role
  //           photoUrl
  //         }
  //         club {
  //           id
  //           name
  //         }
  //       }
  //     }
  //   ''';
  //
  //   final response = await http.post(
  //     Uri.parse(url),
  //     headers: headers,
  //     body: jsonEncode({
  //       'query': query,
  //     }),
  //   );
  //   if (response.statusCode == 200) {
  //     print("POST request successful");
  //     print('Response: ${response.body}');
  //
  //     Map<String, dynamic> data = jsonDecode(response.body);
  //
  //     if(data['errors'] != null) {
  //       final errorMessage = data['errors'][0]['extensions']['message'];
  //       CustomSnackBar.show(context, message: errorMessage, color: Colors.redAccent);
  //     }
  //
  //     final post = (data['data'])['createPost'];
  //     return Post.fromJson(post);
  //   } else {
  //     print("POST request failed");
  //     print('Response: ${response.body}');
  //     throw Exception('Failed to create post');
  //   }
  // }
  //
  // static Future<List<UserModel>> updateUserRole(context, email, role) async {
  //
  //   if(!isInternetConnectionAvailable()) {
  //     CustomGetSnackBar.show(message: "No Internet connection", color: Colors.red.withOpacity(0.5));
  //     throw Exception('No internet connection');
  //   }
  //
  //   print("Updating role...");
  //   const url = 'http://10.0.2.2:4000/graphql';
  //
  //   final token = await SharedPrefs.getToken();
  //
  //   print('token: $token');
  //
  //   Map<String, String> headers = {
  //     'Content-Type': 'application/json',
  //     'Authorization': 'Bearer $token'
  //   };
  //
  //   final query = '''
  //     mutation {
  //       updateUser(email: "$email", role: "$role") {
  //         name
  //         role
  //         id
  //       }
  //     }
  //   ''';
  //
  //   final response = await http.post(
  //     Uri.parse(url),
  //     headers: headers,
  //     body: jsonEncode({
  //       'query': query,
  //     }),
  //   );
  //   if (response.statusCode == 200) {
  //     print("POST request successful");
  //     print('Response: ${response.body}');
  //
  //     Map<String, dynamic> data = jsonDecode(response.body);
  //
  //     if(data['errors'] != null) {
  //       final errorMessage = data['errors'][0]['extensions']['message'];
  //       CustomSnackBar.show(context, message: errorMessage, color: Colors.redAccent);
  //     }
  //
  //     return fetchAdminUsers();
  //   } else {
  //     print("POST request failed");
  //     print('Response: ${response.body}');
  //     throw Exception('Failed to update role');
  //   }
  // }
  //
  // static Future<List<UserModel>> fetchAdminUsers() async {
  //
  //   if(!isInternetConnectionAvailable()) {
  //     CustomGetSnackBar.show(message: "No Internet connection", color: Colors.red.withOpacity(0.5));
  //     throw Exception('No internet connection');
  //   }
  //
  //   print("Fetching admins...");
  //   const url = 'http://10.0.2.2:4000/graphql';
  //
  //   final token = await SharedPrefs.getToken();
  //
  //   print('token: $token');
  //
  //   Map<String, String> headers = {
  //     'Content-Type': 'application/json',
  //     'Authorization': 'Bearer $token'
  //   };
  //
  //   const query = '''
  //     query {
  //       getUsers(role: "admin") {
  //         id
  //         name
  //         email
  //         role
  //         photoUrl
  //       }
  //     }
  //   ''';
  //
  //   final response = await http.post(
  //     Uri.parse(url),
  //     headers: headers,
  //     body: jsonEncode({
  //       'query': query,
  //     }),
  //   );
  //   if (response.statusCode == 200) {
  //     print("POST request successful");
  //     print('Response: ${response.body}');
  //     Map<String, dynamic> data = jsonDecode(response.body);
  //     final users = (data['data'])['getUsers'];
  //     final adminUserList = users.map<UserModel>((user) => UserModel.fromJson(user)).toList();
  //     return adminUserList;
  //   } else {
  //     print("POST request failed");
  //     print('Response: ${response.body}');
  //     throw Exception('Failed to fetch admins');
  //   }
  // }
  //
  // static Future<List<Club>> addMembersToClub(context, clubId, userEmail) async {
  //
  //   if(!isInternetConnectionAvailable()) {
  //     CustomGetSnackBar.show(message: "No Internet connection", color: Colors.red.withOpacity(0.5));
  //     throw Exception('No internet connection');
  //   }
  //
  //   print("Adding to club...");
  //   print("clubId: $clubId, userEmail: $userEmail");
  //   const url = 'http://10.0.2.2:4000/graphql';
  //
  //   final token = await SharedPrefs.getToken();
  //
  //   print('token: $token');
  //
  //   Map<String, String> headers = {
  //     'Content-Type': 'application/json',
  //     'Authorization': 'Bearer $token'
  //   };
  //
  //   final query = '''
  //     mutation {
  //       addToClub(clubId: "$clubId", userEmail: "$userEmail") {
  //         id
  //         name
  //       }
  //     }
  //   ''';
  //
  //   final response = await http.post(
  //     Uri.parse(url),
  //     headers: headers,
  //     body: jsonEncode({
  //       'query': query,
  //     }),
  //   );
  //   if (response.statusCode == 200) {
  //     print("POST request successful");
  //     print('Response: ${response.body}');
  //
  //     Map<String, dynamic> data = jsonDecode(response.body);
  //
  //     if(data['errors'] != null) {
  //       final errorMessage = data['errors'][0]['extensions']['message'];
  //       CustomSnackBar.show(context, message: errorMessage, color: Colors.redAccent);
  //     }
  //
  //     return fetchClubs();
  //   } else {
  //     print("POST request failed");
  //     print('Response: ${response.body}');
  //     throw Exception('Failed to update role');
  //   }
  // }
  //
  // static Future<List<Club>> removeMembersFromClub(context, clubId, userEmail) async {
  //
  //   if(!isInternetConnectionAvailable()) {
  //     CustomGetSnackBar.show(message: "No Internet connection", color: Colors.red.withOpacity(0.5));
  //     throw Exception('No internet connection');
  //   }
  //
  //   print("Removing from club...");
  //   print("clubId: $clubId, userEmail: $userEmail");
  //   const url = 'http://10.0.2.2:4000/graphql';
  //
  //   final token = await SharedPrefs.getToken();
  //
  //   print('token: $token');
  //
  //   Map<String, String> headers = {
  //     'Content-Type': 'application/json',
  //     'Authorization': 'Bearer $token'
  //   };
  //
  //   final query = '''
  //     mutation {
  //       removeFromClub(clubId: "$clubId", userEmail: "$userEmail") {
  //         id
  //         name
  //       }
  //     }
  //   ''';
  //
  //   final response = await http.post(
  //     Uri.parse(url),
  //     headers: headers,
  //     body: jsonEncode({
  //       'query': query,
  //     }),
  //   );
  //   if (response.statusCode == 200) {
  //     print("POST request successful");
  //     print('Response: ${response.body}');
  //
  //     Map<String, dynamic> data = jsonDecode(response.body);
  //
  //     if(data['errors'] != null) {
  //       final errorMessage = data['errors'][0]['extensions']['message'];
  //       CustomSnackBar.show(context, message: errorMessage, color: Colors.redAccent);
  //     }
  //
  //     return fetchClubs();
  //   } else {
  //     print("POST request failed");
  //     print('Response: ${response.body}');
  //     throw Exception('Failed to update role');
  //   }
  // }
  //
  // static Future<String> uploadImage(XFile image) async {
  //
  //   if(!isInternetConnectionAvailable()) {
  //     CustomGetSnackBar.show(message: "No Internet connection", color: Colors.red.withOpacity(0.5));
  //     throw Exception('No internet connection');
  //   }
  //
  //   String filename = '${DateTime.now().millisecondsSinceEpoch}.png';
  //   final credentials = AwsClientCredentials(accessKey: AWS_ACCESS_KEY, secretKey: AWS_SECRET_KEY);
  //   final api = S3(region: 'ap-south-1', credentials: credentials);
  //   await api.putObject(
  //     bucket: 'clubs-app-bucket',
  //     key: filename,
  //     body: File(image.path).readAsBytesSync(),
  //   );
  //   api.close();
  //   print("https://clubs-app-bucket.s3.ap-south-1.amazonaws.com/$filename");
  //   return "https://clubs-app-bucket.s3.ap-south-1.amazonaws.com/$filename";
  // }
  //
  // static Future<List<Club>> updateClubInfo(context, id, name, description, imageUrl) async {
  //
  //   if(!isInternetConnectionAvailable()) {
  //     CustomGetSnackBar.show(message: "No Internet connection", color: Colors.red.withOpacity(0.5));
  //     throw Exception('No internet connection');
  //   }
  //
  //   print("Creating posts...");
  //   const url = 'http://10.0.2.2:4000/graphql';
  //
  //   final token = await SharedPrefs.getToken();
  //
  //   print('token: $token');
  //
  //   Map<String, String> headers = {
  //     'Content-Type': 'application/json',
  //     'Authorization': 'Bearer $token'
  //   };
  //
  //   final query = '''
  //     mutation {
  //       updateClub(id: "$id", name: "$name", description: "$description", imageUrl: "$imageUrl") {
  //         id
  //         name
  //       }
  //     }
  //   ''';
  //
  //   final response = await http.post(
  //     Uri.parse(url),
  //     headers: headers,
  //     body: jsonEncode({
  //       'query': query,
  //     }),
  //   );
  //   if (response.statusCode == 200) {
  //     print("POST request successful");
  //     print('Response: ${response.body}');
  //
  //     Map<String, dynamic> data = jsonDecode(response.body);
  //
  //     if(data['errors'] != null) {
  //       final errorMessage = data['errors'][0]['extensions']['message'];
  //       CustomSnackBar.show(context, message: errorMessage, color: Colors.redAccent);
  //       throw Exception('Failed to update club');
  //     }
  //
  //     return fetchClubs();
  //
  //   } else {
  //     print("POST request failed");
  //     print('Response: ${response.body}');
  //     throw Exception('Failed to update club');
  //   }
  // }
  //
  // static Future<List<Post>> updatePost(context, id, content) async {
  //
  //   if(!isInternetConnectionAvailable()) {
  //     CustomGetSnackBar.show(message: "No Internet connection", color: Colors.red.withOpacity(0.5));
  //     throw Exception('No internet connection');
  //   }
  //
  //   print("Creating posts...");
  //   const url = 'http://10.0.2.2:4000/graphql';
  //
  //   final token = await SharedPrefs.getToken();
  //
  //   print('token: $token');
  //
  //   Map<String, String> headers = {
  //     'Content-Type': 'application/json',
  //     'Authorization': 'Bearer $token'
  //   };
  //
  //   final query = '''
  //     mutation {
  //       updatePost(id: "$id", content: "$content") {
  //         id
  //         content
  //         imageUrl
  //         dateCreated
  //         createdBy {
  //           id
  //           name
  //           email
  //           role
  //           photoUrl
  //         }
  //         club {
  //           id
  //           name
  //         }
  //       }
  //     }
  //   ''';
  //
  //   final response = await http.post(
  //     Uri.parse(url),
  //     headers: headers,
  //     body: jsonEncode({
  //       'query': query,
  //     }),
  //   );
  //   if (response.statusCode == 200) {
  //     print("POST request successful");
  //     print('Response: ${response.body}');
  //
  //     Map<String, dynamic> data = jsonDecode(response.body);
  //
  //     if(data['errors'] != null) {
  //       final errorMessage = data['errors'][0]['extensions']['message'];
  //       CustomSnackBar.show(context, message: errorMessage, color: Colors.redAccent);
  //       throw Exception('Failed to update post');
  //     }
  //
  //     return fetchPosts();
  //   } else {
  //     print("POST request failed");
  //     print('Response: ${response.body}');
  //     throw Exception('Failed to update post');
  //   }
  // }
  //
  // static Future<List<Post>> deletePost(context, id) async {
  //
  //   if(!isInternetConnectionAvailable()) {
  //     CustomGetSnackBar.show(message: "No Internet connection", color: Colors.red.withOpacity(0.5));
  //     throw Exception('No internet connection');
  //   }
  //
  //   print("Creating posts...");
  //   const url = 'http://10.0.2.2:4000/graphql';
  //
  //   final token = await SharedPrefs.getToken();
  //
  //   print('token: $token');
  //
  //   Map<String, String> headers = {
  //     'Content-Type': 'application/json',
  //     'Authorization': 'Bearer $token'
  //   };
  //
  //   print('Postid: $id');
  //
  //   final query = '''
  //     mutation {
  //       deletePost(id: "$id")
  //     }
  //   ''';
  //
  //   final response = await http.post(
  //     Uri.parse(url),
  //     headers: headers,
  //     body: jsonEncode({
  //       'query': query,
  //     }),
  //   );
  //   if (response.statusCode == 200) {
  //     print("POST request successful");
  //     print('Response: ${response.body}');
  //
  //     Map<String, dynamic> data = jsonDecode(response.body);
  //
  //     if(data['errors'] != null) {
  //       final errorMessage = data['errors'][0]['extensions']['message'];
  //       CustomSnackBar.show(context, message: errorMessage, color: Colors.redAccent);
  //       throw Exception('Failed to update post');
  //     }
  //
  //     return fetchPosts();
  //   } else {
  //     print("POST request failed");
  //     print('Response: ${response.body}');
  //     throw Exception('Failed to update post');
  //   }
  // }






}
