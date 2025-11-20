$(document).ready(function() {
    if (!$.fn.DataTable.isDataTable('#branchesTable')) {
        $('#branchesTable').DataTable({
            "ajax": `${BASE_URL}/Owner/processes/profile/branches/load_branches.php`,
            "pageLength": 20,
            "lengthChange": false,
            "ordering": true,
            "searching": true,
            "columns": [
                { "title": "ID" },
                { "title": "Branch Name" },
                { "title": "Phone Number" },
                { "title": "Status" },
                { "title": "Action", "orderable": false }
            ],
            "order": [[0, "asc"]],
            "language": {
                search: "",
                searchPlaceholder: "Search"
            },
            "initComplete": function() {
                const $searchInput = $('#branchesTable_filter input[type=search]');
                $searchInput.attr('id', 'branchesSearch').attr('name', 'branchesSearch');
                $('#branchesTable_filter label').attr('for', 'branchesSearch');

                $('#branchesTable_filter').append(
                    '<button id="insertBranchBtn">+ Add</button>'
                );
            }
        });
    }
});
