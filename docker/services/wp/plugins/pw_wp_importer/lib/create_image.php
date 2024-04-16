<?php

create_image($text="1", $name=__DIR__.'/../data/assets/image1.jpg');
create_image($text="2", $name=__DIR__.'/../data/assets/image2.jpg');
create_image($text="3", $name=__DIR__.'/../data/assets/image3.jpg');
create_image($text="4", $name=__DIR__.'/../data/assets/image4.jpg');



function create_image($text, $name){
    // Create a new image
    $image = imagecreatetruecolor(200, 200);

    // Allocate colors
    $white = imagecolorallocate($image, 255, 255, 255);
    $black = imagecolorallocate($image, 0, 0, 0);

    // Fill the background with white color
    imagefilledrectangle($image, 0, 0, 200, 200, $white);

    // Set the path to the font file (you may need to adjust this depending on your system)
    $font = '/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf';
    // $text = '1';

    // Add the text
    imagettftext($image, 20, 0, 60, 120, $black, $font, $text);

    // Save the image as 'image1.jpg'
    imagejpeg($image, $name);

    // Free up memory
    imagedestroy($image);
}
