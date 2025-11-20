<?php
include("php/query.php");

$categoryNameErr = $categoryImageNameErr = $categoryDesErr = "";
$category = ['id'=>0, 'name'=>'', 'des'=>'', 'image'=>'']; // default

if(isset($_GET['cId'])){
    $categoryId = $_GET['cId'];
    $query = $pdo->prepare("SELECT * FROM categories WHERE id = :catId");
    $query->bindParam(":catId", $categoryId);
    $query->execute();
    $category = $query->fetch(PDO::FETCH_ASSOC);
}

// Update logic
if(isset($_POST['updateCategory'])){
    $cName = $_POST['cName'];
    $cDes  = $_POST['cDes'];
    $categoryId = $category['id']; // from fetched record

    // Validation
    if(empty($cName)) $categoryNameErr = "Name is required";
    if(empty($cDes))  $categoryDesErr  = "Description is required";

    if(empty($categoryNameErr) && empty($categoryDesErr)){
        // Check if new image is uploaded
        if(!empty($_FILES['cImage']['name'])){
            // New image uploaded
            $imageName = $_FILES['cImage']['name'];
            $tmpName   = $_FILES['cImage']['tmp_name'];
            $extension = pathinfo($imageName, PATHINFO_EXTENSION);
            $allowed   = ['jpg','jpeg','png','gif'];

            if(in_array(strtolower($extension), $allowed)){
                $newImageName = uniqid("CAT_") . "." . $extension;
                move_uploaded_file($tmpName, "images/".$newImageName);

                // Delete old image (optional)
                if(file_exists("images/".$category['image']) && $category['image'] != ""){
                    unlink("images/".$category['image']);
                }

                $imageToSave = $newImageName;
            } else {
                $categoryImageNameErr = "Invalid image format";
                $imageToSave = $category['image']; // keep old
            }
        } else {
            $imageToSave = $category['image']; // no new image
        }

        if(empty($categoryImageNameErr)){
            $query = $pdo->prepare("UPDATE categories SET name = :name, des = :des, image = :image WHERE id = :id");
            $query->bindParam(':name', $cName);
            $query->bindParam(':des', $cDes);
            $query->bindParam(':image', $imageToSave);
            $query->bindParam(':id', $categoryId);

            if($query->execute()){
                echo "<script>alert('Category updated successfully'); location.assign('select.php');</script>";
            } else {
                echo "<script>alert('Update failed');</script>";
            }
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
  <body>    <?php
                if(isset($_GET['cId'])){
                    $categoryId = $_GET['cId'];
                    $query = $pdo->prepare("select * from categories where id = :catId");
                    $query->bindParam("catId",$categoryId);
                    $query->execute();
                    $category = $query->fetch(PDO::FETCH_ASSOC);
                    print_r($category);
                }
  ?>
    
            <div class="container p-5">
                <form action="" method="post" enctype="multipart/form-data">
                    <div class="form-group">
                      <label for="">Name</label>
                      <input type="text" value="<?php echo $category['name']?>" name="cName" id="" class="form-control" placeholder="" aria-describedby="helpId">
                      <small id="helpId" class="text-danger"><?php echo $categoryNameErr?></small>
                    </div>
                    <div class="form-group">
                      <label for="">Image</label>
                      <input type="file" name="cImage" id="" class="form-control" placeholder="" aria-describedby="helpId">
                      <small id="helpId" class="text-danger"><?php echo $categoryImageNameErr?></small>
                      <img src="images/<?php echo $category['image']?>" alt="">
                    </div>
                    <div class="form-group">
                      <label for="">Description</label>
                      <textarea type="text" name="cDes" id="" class="form-control" placeholder="" aria-describedby="helpId"><?php echo $category['des']?></textarea>
                      <small id="helpId" class="text-danger"><?php echo $categoryDesErr?></small>

                    </div>

                    <button class="btn-info btn" name="updateCategory">Update Category</button>
                </form>
            </div>
    
  </body>
</html>