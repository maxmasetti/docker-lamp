<pre>
<?php

#phpinfo(); die;

$db = mysqli_connect("db", "root", "root", "books");

if (!$db) {
    echo "Error: Unable to connect to MySQL." . PHP_EOL;
    echo "Debugging errno: " . mysqli_connect_errno() . PHP_EOL;
    echo "Debugging error: " . mysqli_connect_error() . PHP_EOL;
    exit;
}

echo "Success: A proper connection to MySQL was made!" . PHP_EOL;
echo "Host information: " . mysqli_get_host_info($db) . PHP_EOL;

$sql = "SHOW VARIABLES";

$table = [];
$rs = mysqli_query($db, $sql);
$r = mysqli_fetch_assoc($rs);
while ($r) {
  $table[] = $r;
  $r = mysqli_fetch_assoc($rs);
}

echo "\nSHOW VARIABLES =>\n";
echo json_encode($table, JSON_PRETTY_PRINT);

mysqli_close($db);
