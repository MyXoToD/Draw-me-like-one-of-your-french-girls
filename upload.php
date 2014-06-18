<?php
$path = 'uploads/'; // upload directory

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
  if( ! empty($_FILES['file']) ) {
    // get uploaded file extension
    $ext = strtolower(pathinfo($_FILES['file']['name'], PATHINFO_EXTENSION));
    if ($ext == "svg") {
      $path = $path . uniqid(). '.' .$ext;
      // move uploaded file from temp to uploads directory
      if (move_uploaded_file($_FILES['file']['tmp_name'], $path)) {
        //echo "<img src='$path' />";
        echo file_get_contents($path);
      }
    } else {
      echo "No SVG!";
    }
} else {
    echo 'error';
  }
} else {
  echo 'error';
}
?>