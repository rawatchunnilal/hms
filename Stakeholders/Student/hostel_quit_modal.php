<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quit Hostel Application</title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/5.1.3/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .warning-text {
            color: #856404;
            background-color: #fff3cd;
            border-color: #ffeeba;
            padding: 10px;
            border-radius: 5px;
            margin-top: 10px;
        }
        .checkbox-container {
            margin-top: 10px;
        }
        .btn-outline-warning.clicked {
            background-color: #ffc107;
            border-color: #ffc107;
            color: white;
        }
    </style>
</head>
<body>
    <div class="modal fade" id="staticBackdrop" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <form id="quitForm" action="quit_requests_control.php" method="post">
                    <div class="modal-header">
                        <h5 class="modal-title" id="staticBackdropLabel">Apply to Quit the Hostel</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <p class="lead">Are you sure?</p>
                        <button type="button" class="btn btn-outline-warning" id="confirmationButton" data-bs-toggle="popover" data-bs-content="Please confirm your decision.">Confirm</button>
                        <div class="warning-text">
                            If you are quitting you need to get approved by the warden and accountant.
                        </div>
                        <div class="checkbox-container">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="returnFurniture" name="returnFurniture">
                                <label class="form-check-label" for="returnFurniture">
                                    I will return all allocated furniture to the hostel.
                                </label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="payFees" name="payFees">
                                <label class="form-check-label" for="payFees">
                                    I will pay the balanced fees. (If applicable)
                                </label>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        <button type="submit" class="btn btn-primary" id="submitButton" disabled>Submit</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/5.1.3/js/bootstrap.bundle.min.js"></script>
    <script>
        $(document).ready(function() {
            $('#confirmationButton').on('click', function() {
                $(this).toggleClass('clicked');
                checkForm();
            });

            $('.form-check-input').on('change', function() {
                checkForm();
            });

            function checkForm() {
                const isConfirmed = $('#confirmationButton').hasClass('clicked');
                const returnFurnitureChecked = $('#returnFurniture').is(':checked');
                const payFeesChecked = $('#payFees').is(':checked');

                if (isConfirmed && returnFurnitureChecked && payFeesChecked) {
                    $('#submitButton').prop('disabled', false);
                } else {
                    $('#submitButton').prop('disabled', true);
                }

                // Update hidden input to send confirmation state
                if (isConfirmed) {
                    $('<input>').attr({
                        type: 'hidden',
                        id: 'confirmationInput',
                        name: 'confirmation',
                        value: 'clicked'
                    }).appendTo('#quitForm');
                } else {
                    $('#confirmationInput').remove();
                }
            }
        });
    </script>
</body>
</html>
