class API {
  static const hostConnect = "http://192.168.3.107/clothes_app_APIs";
  static const hostConnectUser = "$hostConnect/user";
  static const hostConnectAdmin = "$hostConnect/admin"; 
  static const hostUploadItem = "$hostConnect/items"; 
  static const hostClothes = "$hostConnect/clothes"; 
  static const hostCart = "$hostConnect/cart"; 
  static const hostFavourite = "$hostConnect/favourite";
  static const hostItems = "$hostConnect/items";
  static const hostOrder = "$hostConnect/order";
  static const hostImages = "$hostConnect/transactions_proof_images/";
  
  //signUp user 
  static const signUp = "$hostConnect/user/signup.php";
  static const validateEmail = "$hostConnect/user/validate_email.php"; 
  static const signIn = "$hostConnect/user/login.php" ;  

  //login admin
  static const adminLogin = "$hostConnectAdmin/login.php"; 
  static const adminGetAllOrders = "$hostConnectAdmin/read_orders.php"; 

  //upload-save new item
  static const uploadItem = "$hostUploadItem/upload.php"; 

  //Clothes 
  static const getTrendingMostPopularClothes = "$hostClothes/trending.php"; 
  static const getClothesbyTypes = "$hostClothes/type.php"  ; 
  static const getAllClothes = "$hostClothes/all.php"; 

  //cart
  static const addToCart = "$hostCart/add.php";
  static const getCartList = "$hostCart/read.php" ; 
  static const deleteSelectedItemFromCartList = "$hostCart/delete.php"; 
  static const updateItemInCartList = "$hostCart/update.php";


  //favourite
  static const validateFavourite = "$hostFavourite/validate_favourite.php";
  static const addFavourite = "$hostFavourite/add.php";
  static const deleteFavourite = "$hostFavourite/delete.php";
  static const readFavourite = "$hostFavourite/read.php";


  //search items 
  static const searchItems = "$hostItems/search.php"; 

  //order 
  static const addOrder = "$hostOrder/add.php";
  static const readOrders = "$hostOrder/read.php";
  static const updateStatus = "$hostOrder/update_status.php"; 
  static const readHistory = "$hostOrder/read_history.php"; 

} 