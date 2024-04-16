<?php 

//TODO: ANALYZE IF THIS CLASS IS BEING USED FOR CREATE CUSTOM TAXONOMIES?

class PW_WP_Importer {
    public function __construct($file) {
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
}
