<?php
include("php/query.php");

// Initialize error variables
$categoryNameErr = $categoryImageNameErr = $categoryDesErr = "";

if(isset($_POST['addCategory'])){
    $cName = $_POST['cName'];
    $cDes  = $_POST['cDes'];

    // Basic validation
    if(empty($cName)) $categoryNameErr = "Name is required";
    if(empty($cDes))  $categoryDesErr  = "Description is required";
    if(empty($_FILES['cImage']['name'])) $categoryImageNameErr = "Image is required";

    // If no errors, process the upload and insert
    if(empty($categoryNameErr) && empty($categoryImageNameErr) && empty($categoryDesErr)){
        $imageName = $_FILES['cImage']['name'];
        $tmpName   = $_FILES['cImage']['tmp_name'];
        $extension = pathinfo($imageName, PATHINFO_EXTENSION);
        $allowed   = ['jpg','jpeg','png','gif'];

        if(in_array(strtolower($extension), $allowed)){
            $newImageName = uniqid("CAT_") . "." . $extension;
            move_uploaded_file($tmpName, "images/".$newImageName);

            $query = $pdo->prepare("INSERT INTO categories (name, des, image) VALUES (:name, :des, :image)");
            $query->bindParam(':name', $cName);
            $query->bindParam(':des', $cDes);
            $query->bindParam(':image', $newImageName);
            
            if($query->execute()){
                echo "<script>alert('Category added successfully'); location.assign('select.php');</script>";
            } else {
                echo "<script>alert('Error adding category');</script>";
            }
        } else {
            $categoryImageNameErr = "Only jpg, jpeg, png, gif allowed";
        }
    }
}
?>
<!doctype html>
<html lang="en">
  <head>
    <title>Title</title>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
  </head>
  <body>
    
            <div class="container p-5">
                <form action="" method="post" enctype="multipart/form-data">
                    <div class="form-group">
                      <label for="">Name</label>
                      <input type="text" name="cName" id="" class="form-control" placeholder="" aria-describedby="helpId">
                      <small id="helpId" class="text-danger"><?php echo $categoryNameErr?></small>
                    </div>
                    <div class="form-group">
                      <label for="">Image</label>
                      <input type="file" name="cImage" id="" class="form-control" placeholder="" aria-describedby="helpId">
                      <small id="helpId" class="text-danger"><?php echo $categoryImageNameErr?></small>
                    </div>
                    <div class="form-group">
                      <label for="">Description</label>
                      <textarea type="text" name="cDes" id="" class="form-control" placeholder="" aria-describedby="helpId"></textarea>
                      <small id="helpId" class="text-danger"><?php echo $categoryDesErr?></small>
                    </div>

                    <button class="btn-info btn" name="addCategory">Add Category</button>
                </form>
            </div>
    
  </body>
</html>