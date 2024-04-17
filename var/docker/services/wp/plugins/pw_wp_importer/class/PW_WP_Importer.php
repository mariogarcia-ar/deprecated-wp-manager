<?php 

//TODO: ANALYZE IF THIS CLASS IS BEING USED FOR CREATE CUSTOM TAXONOMIES?

class PW_WP_Importer {
    public function __construct($file=false) {
        $this->file = $file;
    }

    /**
     * Read the CSV file and return the data as an array.
     *
     * @param int $length The maximum length of a line.
     * @param string $delimiter The field delimiter.
     * @param string $enclosure The field enclosure character.
     * @param string $escape The escape character.
     * @return array The data read from the CSV file.
     * @throws Exception If there is an error reading the file.
     */
    public function readCSV($length=0, $delimiter=",", $enclosure='"', $escape="\\") {
        $data = array(); $header = array(); 
        $handle = fopen($this->file, "r");
        if ($handle) {
            while (($row = fgetcsv($handle, $length, $delimiter, $enclosure, $escape)) !== false) {
                if (empty($header)) {
                    $header = $row;
                } else {
                    $data[] = array_combine($header, $row);
                }
            }
            fclose($handle);
        } else {
            throw new Exception("Error reading file");
        }
        return $data;
    }

    /**
     * Import taxonomy terms in bulk from the CSV file.
     *
     * @param string $taxonomy The taxonomy to import terms into.
     */
    public function importTaxonomyBulk($taxonomy="category") {
        $data = $this->readCSV();
        foreach ($data as $row) {
            $name = $row['name'];
            $_taxonomy = $row['taxonomy']? $row['taxonomy'] : $taxonomy;
            $term_id = term_exists($name, $_taxonomy);
            if ($term_id) {
                echo "\n ${name} already exists";
            } else {
                $term = wp_insert_term($name, $_taxonomy);
                if (is_wp_error($term)) {
                    echo "\n Error: ". $term->get_error_message();
                } else {
                    echo "\n ${name} has been created";
                }
            }
        }
    }

    /**
     * Import a single taxonomy term.
     *
     * @param string $name The name of the term.
     * @param string $taxonomy The taxonomy to import the term into.
     * @return int The term ID of the imported term.
     * @throws Exception If there is an error importing the term.
     */
    public function importTaxonomy($name, $taxonomy) {
        $term_id = term_exists($name, $taxonomy);
        if ($term_id) {
            return $term_id['term_id'];
        } else {
            $term = wp_insert_term($name, $taxonomy);
            if (is_wp_error($term)) {
                throw new Exception($term->get_error_message());
            } else {
                return $term['term_id'];
            }
        }
    }

    /**
     * Import a category term.
     *
     * @param string $name The name of the category.
     * @return int The term ID of the imported category.
     * @throws Exception If there is an error importing the category.
     */
    public function importCategory($name) {
        return $this->importTaxonomy($name, 'category');
    }

    /**
     * Import a tag term.
     *
     * @param string $name The name of the tag.
     * @return int The term ID of the imported tag.
     * @throws Exception If there is an error importing the tag.
     */
    public function importTag($name) {
        return $this->importTaxonomy($name, 'post_tag');
    }

    /**
     * Import users in bulk from the CSV file.
     */
    public function importUserBulk() {
        $data = $this->readCSV();
        foreach ($data as $row) {
            $name = $row['name'];
            $email = $row['email'];
            $password = $row['password'];
            $user_id = $this->importUser($name, $email, $password);
            if (is_wp_error($user_id)) {
                echo "\n Error: ". $user_id->get_error_message();
            } else {
                echo "\n ${name} has been created";
            }
        }
    }
    

    /**
     * Import a user.
     *
     * @param string $name The name of the user.
     * @param string $email The email of the user.
     * @param string $password The password of the user.
     * @return int The user ID of the imported user.
     * @throws Exception If there is an error importing the user.
     */
    public function importUser($name, $email, $password) {
        $user_id = username_exists($name);
        if (!$user_id) {
            $user_id = email_exists($email);
        }
        if ($user_id) {
            return $user_id;
        } else {
            $user_id = wp_create_user($name, $password, $email);
            if (is_wp_error($user_id)) {
                throw new Exception($user_id->get_error_message());
            } else {
                return $user_id;
            }
        }
    }

    /**
     * Import posts in bulk from the CSV file.
     */
    public function importAttachmentBulk($post_id=1) {
        $data = $this->readCSV();
        foreach ($data as $row) {
            $file = $row['file_path'];
            $_post_id = $row['_post_id']? $row['_post_id'] : $post_id;
            $attachment_id = $this->importAttachment($file, $_post_id);
            if (is_wp_error($attachment_id)) {
                echo "\n Error: ". $attachment_id->get_error_message();
            } else {
                echo "\n ${file} has been created";
            }
        }
    }

    /**
     * Import an attachment.
     *
     * @param string $file_path The path to the file.
     * @param int $post_id The post ID to attach the file to.
     * @return int The attachment ID of the imported attachment.
     * @throws Exception If there is an error importing the attachment.
     */
    function importAttachment ($file_path, $post_id){
        // Prepare the file for upload
        $file = array(
            'name' => basename($file_path),
            'type' => wp_check_filetype(basename($file_path), null),
            'tmp_name' => $file_path,
            'error' => 0,
            'size' => filesize($file_path)
        );
        
        // Upload the file
        $overrides = array(
            'test_form' => false,
            'test_size' => true,
        );
        $file_data = wp_handle_sideload($file, $overrides);
        
        if (isset($file_data['error'])) {
            // Handle the error
            echo $file_data['error'];
            return;
        }
        
        // Prepare the attachment for insertion
        $attachment = array(
            'guid' => $file_data['url'],
            'post_mime_type' => $file_data['type'],
            'post_title' => preg_replace('/\.[^.]+$/', '', basename($file_path)),
            'post_content' => '',
            'post_status' => 'inherit'
        );
        
        // Insert the attachment
        $attach_id = wp_insert_attachment($attachment, $file_data['file'], $post_id);
        
        // Include the image.php file for the function wp_generate_attachment_metadata()
        require_once(ABSPATH . 'wp-admin/includes/image.php');
        
        // Generate the metadata for the attachment and update the database record
        $attach_data = wp_generate_attachment_metadata($attach_id, $file_data['file']);
        wp_update_attachment_metadata($attach_id, $attach_data);        
    }
    
    /**
     * Import posts in bulk from the CSV file.
     */
    public function importPostBulk() {
        $data = $this->readCSV();
        foreach ($data as $row) {
            $title = $row['title'];
            $content = $row['content'];
            $author = $row['author'];
            $category = $row['category'];
            $tags = $row['tags'];
            $post_date = $row['post_date'];
            $post_status = $row['post_status'];
            $post_type = $row['post_type'];
            $post_id = $this->importPost($title, $content, $author, $category, $tags, $post_date, $post_status, $post_type);
            if (is_wp_error($post_id)) {
                echo "\n Error: ". $post_id->get_error_message();
            } else {
                echo "\n ${title} has been created";
            }
        }
    }
    

    /**
     * Import a post.
     *
     * @param string $title The title of the post.
     * @param string $content The content of the post.
     * @param int $author The author ID of the post.
     * @param int $category The category ID of the post.
     * @param string $tags The tags of the post.
     * @param string $post_date The date of the post.
     * @param string $post_status The status of the post.
     * @param string $post_type The type of the post.
     * @return int The post ID of the imported post.
     * @throws Exception If there is an error importing the post.
     */
    public function importPost($title, $content, $author, $category, $tags, $post_date, $post_status, $post_type='post') {
        $post_id = post_exists($title, $content, $post_date);
        if ($post_id) {
            return $post_id;
        } else {
            $post_data = array(
                'post_title' => $title,
                'post_content' => $content,
                'post_author' => $author,
                'post_category' => array($category),
                'tags_input' => $tags,
                'post_date' => $post_date,
                'post_status' => $post_status,
                'post_type' => $post_type
            );
            $post_id = wp_insert_post($post_data);
            if (is_wp_error($post_id)) {
                return $post_id;
            } else {
                return $post_id;
            }
        }
    }
    

    /**
     * Import post meta in bulk from the CSV file.
     */
    public function importPostMetaBulk() {
        $data = $this->readCSV();
        foreach ($data as $row) {
            $post_id = $row['post_id'];
            $meta_key = $row['meta_key'];
            $meta_value = $row['meta_value'];
            $meta_id = $this->importPostMeta($post_id, $meta_key, $meta_value);
            if (is_wp_error($meta_id)) {
                echo "\n Error: ". $meta_id->get_error_message();
            } else {
                echo "\n ${meta_key} has been created";
            }
        }
    }
    
    /**
     * Import post meta.
     * 
     * @param int $post_id The post ID.
     * @param string $meta_key The meta key.
     * @param string $meta_value The meta value.
     * @return int The meta ID of the imported meta.
     */
    public function importPostMeta($post_id, $meta_key, $meta_value) {
        $meta_id = add_post_meta($post_id, $meta_key, $meta_value);
        if (is_wp_error($meta_id)) {
            return $meta_id;
        } else {
            return $meta_id;
        }
    }

    /**
     * Import post thumbnail in bulk from the CSV file.
     */
    public function importThumbnailBulk() {
        $data = $this->readCSV();
        foreach ($data as $row) {
            $post_id = $row['post_id'];
            $file_path = $row['file_path'];
            $res = $this->importThumbnail($post_id, $file_path);
            if (is_wp_error($res)) {
                echo "\n Error: setting thumbnail for post ${post_id}";
            }else{
                echo "\n ${file_path} has been set as the thumbnail for post ${post_id}";
            }            
        }
    }


    /**
     * Import post thumbnail.
     * 
     * @param int $post_id The post ID.
     * @param string $file_path The path to the file.
     * @return bool True if the thumbnail is set, false otherwise.
     */
    public function importThumbnail($post_id, $file_path) {
        $attachment_id = $this->importAttachment($file_path, $post_id);
        if (is_wp_error($attachment_id)) {
            echo "\n Error: ". $attachment_id->get_error_message();
        } else {
            $res = set_post_thumbnail($post_id, $attachment_id);
            return $res;
        }
    }

    
    private function copyDirectory($source, $destination) {
        if (is_dir($source)) {
            @mkdir($destination);
            $files = scandir($source);
            foreach ($files as $file) {
                if ($file != "." && $file != "..") {
                    $this->copyDirectory("$source/$file", "$destination/$file");
                }
            }
        } else if (file_exists($source)) {
            copy($source, $destination);
        }
    }
        
    /**
     * Backup the uploads folder.
     * 
     * @param string $backup_folder The folder to backup to.
     * 
     */
    public function restoreBackup($backup_folder) {
        $upload_dir = wp_upload_dir();
        $upload_dir = $upload_dir['basedir'];

        echo "\n Restoring backup  ${backup_folder}uploads to $upload_dir";
        $this->copyDirectory($backup_folder, $upload_dir."/../");
        // $this->copyDirectory($backup_folder . "/uploads", $upload_dir);
        echo "\n Backup restored";
    }

}
