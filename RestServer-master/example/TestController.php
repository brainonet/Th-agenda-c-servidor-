<?php
use \Jacwright\RestServer\RestException;

class TestController{
    /*
     *
     * @url GET /getAll
     * @url GET /getAll/$id
    */
    public function getAll($id = null){
        $res;
        $conn = new mysqli('localhost', 'root', 'root', 'contactos_db');

        if(!$id){
            $res = $conn->query("SELECT * FROM contactos_tbl");
        }else {
            $res = $conn->query("SELECT * FROM contactos_tbl WHERE id=$id");
        }

        $rows = array();
        
        while($r = $res->fetch_array(MYSQLI_ASSOC)) {
            $rows[] = $r;
        }

        $conn->close();
        echo json_encode($rows);
        // echo $rows;        
    }
    
    /*
     *
     * @url POST /addContacto
    */
    public function addContacto(){
        $conn = new mysqli('localhost', 'root', 'root', 'contactos_db');
        
        $nome = $_POST['nome'];
        $apelido = $_POST['apelido'];
        $tlm = $_POST['contacto'];
         
        $res = $conn->query("INSERT INTO contactos_tbl (nome, apelido, telemovel) VALUES ('$nome','$apelido','$tlm')");
        
        $conn->close();
    }

    
    
    /**
     * @url GET /deleta
     */
    public function deleta(){
        $conn = new mysqli('localhost', 'root', 'root', 'contactos_db');
        $res = $conn->query("DELETE FROM contatos_tbl");
        $conn->close();
        echo "deleted";
    }
    
    

    /*
     *
     * @url PUT /updateContacto/$id
    */
    public function updateContacto($id){
        $conn = new mysqli('localhost', 'root', 'root', 'contactos_db');

        $id = $_POST['id'];
        $nome = $_POST['nome'];
        $apelido = $_POST['apelido'];
        $tlm = $_POST['contacto']; 
        
        $res = $conn->query("UPDATE `contactos_tbl` SET `nome`='$nome',`apelido`='$apelido',`contacto`='$tlm' WHERE id = $id");
        $conn->close();
    }
    
    
    
    /*
     *
     * @url DELETE /$id
    */
    public function deleteContacto($id){
        $conn = new mysqli('localhost', 'root', 'root', 'contactos_db');
        $res = $conn->query("DELETE FROM `contactos_tbl` WHERE id = $id");
        $conn->close();
    }
    
    
    
    /**
     * Throws an error
     * 
     * @url GET /error
     */
    public function throwError() {
        throw new RestException(401, "Empty password not allowed");
    }
}