<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Document</title>
  <style></style>
</head>

<body>
  <?php
  include '../../php/connection/connect.php';

  // Function to determine color class based on count
  function getColorClass($count)
  {
    if ($count == 0) {
      return 'vacant';
    } elseif ($count == 1) {
      return 'half';
    } elseif ($count == 2) {
      return 'full';
    }
  }

  // Define the session variable value
  $session_value = 1; // Assuming session variable value is 1 or 2

  // Your SQL query
  $sql = "SELECT room_id, COALESCE(COUNT(student_id), 0) AS count FROM alloted GROUP BY room_id";
  $result = $conn->query($sql);

  // Check if query was successful
  if ($result->num_rows > 0) {

    echo '<div class="container-fluid below-navbar" style="width: 100%" id="below_nav">';
    // Output data of each row
    echo '<link rel="stylesheet" href="../../css/checkRooms.css" />';

    $num = 1;
    $currentSlot = 0;

    while ($row = $result->fetch_assoc()) {
      $count = $row['count'];
      $colorClass = getColorClass($count);

      // Fetch student details for the current room
      $room_id = $row['room_id'];
      $student_sql = "SELECT Fullname, EN FROM student WHERE EN IN (SELECT student_id FROM alloted WHERE room_id = $room_id)";
      $student_result = $conn->query($student_sql);

      $student_details = '';
      if ($student_result->num_rows > 0) {
        while ($student_row = $student_result->fetch_assoc()) {
          $student_details .= $student_row['Fullname'] . ' (' . $student_row['EN'] . ') ';
        }
      } else {
        $student_details = 'No students assigned to this room.';
      }

      if (($session_value == 1 && $num <= 60) || ($session_value == 2 && $num > 60 && $num <= 120)) {
        $slot = ($session_value == 1) ? (int)(($num - 1) / 15) + 1 : (int)(($num - 61) / 15) + 1;

        if ($slot !== $currentSlot) {
          if ($currentSlot !== 0) {
            echo '</div>'; // Close the previous row div
          }
          $currentSlot = $slot;

          // Print heading based on the slot
          switch ($slot) {
            case 1:
              echo '<div class="sub-heading">First Year</div>';
              break;
            case 2:
              echo '<div class="sub-heading">Second Year</div>';
              break;
            case 3:
              echo '<div class="sub-heading">Third Year</div>';
              break;
            case 4:
              echo '<div class="sub-heading">Fourth Year</div>';
              break;
          }
          echo '<div class="row">';
        }

        echo '<button class="room-box" type="button" class="btn btn-secondary" data-bs-toggle="popover" data-bs-trigger="focus"';
        echo 'data-bs-content="' . $student_details . '">';
        echo '<div class="in-box ' . $colorClass . '">';
        echo $num;
        echo '</div>';
        echo '</button>';
      }
      $num++;
    }
    echo '</div></div>';
    // Close the last row div
  } else {
    echo "0 results";
  }

  include '../../php/connection/break.php';
  ?>



  <!--// Add Bootstrap and Popover Initialization
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
<script>
  document.addEventListener("DOMContentLoaded", function() {
    const popoverTriggerList = document.querySelectorAll('[data-bs-toggle="popover"]');
    const popoverList = [...popoverTriggerList].map((popoverTriggerEl) => new bootstrap.Popover(popoverTriggerEl));
  });
</script>
 -->
</body>

</html>