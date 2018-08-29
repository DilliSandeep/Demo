<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DOM.aspx.cs" Inherits="CrudOperations.DOM" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">



<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>
<style type="text/css">
        body
        {
            font-family: Arial;
            font-size: 10pt;
        }
        table
        {
            border: 1px solid #ccc;
            width: 550px;
            margin-bottom: -1px;
        }
        table th
        {
            background-color: #F7F7F7;
            color: #333;
            font-weight: bold;
        }
        table th, table td
        {
            padding: 5px;
            border: 1px solid #ccc;
        }
    </style>



    <title></title>
</head>
<center>
<body>
    <form id="form1" runat="server">
    <asp:GridView ID="gvCustomers" runat="server" AutoGenerateColumns="false">
        <Columns>
            <asp:TemplateField HeaderText="Customer Id" ItemStyle-Width="110px" ItemStyle-CssClass="CustomerId">
                <ItemTemplate>
                    <asp:Label ID="Label1" Text='<%# Eval("CustomerId") %>' runat="server" />
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Name" ItemStyle-Width="150px" ItemStyle-CssClass="Name">
                <ItemTemplate>
                    <asp:Label ID="Label2" Text='<%# Eval("Name") %>' runat="server" />
                    <asp:TextBox ID="TextBox1" Text='<%# Eval("Name") %>' runat="server" Style="display: none" />
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Country" ItemStyle-Width="150px" ItemStyle-CssClass="Country">
                <ItemTemplate>
                    <asp:Label ID="Label3" Text='<%# Eval("Country") %>' runat="server" />
                    <asp:TextBox ID="TextBox2" Text='<%# Eval("Country") %>' runat="server" Style="display: none" />
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField>
                <ItemTemplate>
                    <asp:LinkButton ID="LinkButton1" Text="Edit" runat="server" CssClass="Edit" />
                    <asp:LinkButton ID="LinkButton2" Text="Update" runat="server" CssClass="Update" Style="display: none" />
                    <asp:LinkButton ID="LinkButton3" Text="Cancel" runat="server" CssClass="Cancel" Style="display: none" />
                    <asp:LinkButton ID="LinkButton4" Text="Delete" runat="server" CssClass="Delete" />
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>
    <table border="1" cellpadding="0" cellspacing="0" style="border-collapse: collapse">
        <tr>
            <td style="width: 150px">
                Name:<br />
                <asp:TextBox ID="txtName" runat="server" Width="140" />
            </td>
            <td style="width: 150px">
                Country:<br />
                <asp:TextBox ID="txtCountry" runat="server" Width="140" />
            </td>
            <td style="width: 100px">
                <br />
                <asp:Button ID="btnAdd" runat="server" Text="Add" />
            </td>
        </tr>
    </table>
    <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>
    <script type="text/javascript">
        $(function () {
            $.ajax({
                type: "POST",
                url: "DOM.aspx/GetCustomers",
                data: '{}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnSuccess
            });
        });

        function OnSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var customers = xml.find("Table");
            var row = $("[id*=gvCustomers] tr:last-child");
            if (customers.length > 0) {
                $.each(customers, function () {
                    var customer = $(this);
                    AppendRow(row, $(this).find("CustomerID").text(), $(this).find("Name").text(), $(this).find("Country").text())
                    row = $("[id*=gvCustomers] tr:last-child").clone(true);
                });
            } else {
                row.find(".Edit").hide();
                row.find(".Delete").hide();
                row.find("span").html('&nbsp;');
            }
        }

        function AppendRow(row, customerId, name, country) {
            //Bind CustomerId.
            $(".CustomerId", row).find("span").html(customerId);

            //Bind Name.
            $(".Name", row).find("span").html(name);
            $(".Name", row).find("input").val(name);

            //Bind Country.
            $(".Country", row).find("span").html(country);
            $(".Country", row).find("input").val(country);

            row.find(".Edit").show();
            row.find(".Delete").show();
            $("[id*=gvCustomers]").append(row);
        }

        //Add event handler.
        $("body").on("click", "[id*=btnAdd]", function () {
            var txtName = $('#txtName').val();
            var txtCountry = $('#txtCountry').val();
            $.ajax({
                type: "POST",
                url: "DOM.aspx/InsertCustomer",
                data: '{name: "' + txtName.val() + '", country: "' + txtCountry.val() + '" }',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    var row = $("[id*=gvCustomers] tr:last-child");
                    if ($("[id*=gvCustomers] tr:last-child span").eq(0).html() != "&nbsp;") {
                        row = row.clone();
                    }
                    AppendRow(row, response.d, txtName.val(), txtCountry.val());
                    txtName.val("");
                    txtCountry.val("");
                }
            });
            return false;
        });

        //Edit event handler.
        $("body").on("click", "[id*=gvCustomers] .Edit", function () {
            var row = $(this).closest("tr");
            $("td", row).each(function () {
                if ($(this).find("input").length > 0) {
                    $(this).find("input").show();
                    $(this).find("span").hide();
                }
            });
            row.find(".Update").show();
            row.find(".Cancel").show();
            row.find(".Delete").hide();
            $(this).hide();
            return false;
        });

        //Update event handler.
        $("body").on("click", "[id*=gvCustomers] .Update", function () {
            var row = $(this).closest("tr");
            $("td", row).each(function () {
                if ($(this).find("input").length > 0) {
                    var span = $(this).find("span");
                    var input = $(this).find("input");
                    span.html(input.val());
                    span.show();
                    input.hide();
                }
            });
            row.find(".Edit").show();
            row.find(".Delete").show();
            row.find(".Cancel").hide();
            $(this).hide();

            var customerId = row.find(".CustomerId").find("span").html();
            var name = row.find(".Name").find("span").html();
            var country = row.find(".Country").find("span").html();
            $.ajax({
                type: "POST",
                url: "DOM.aspx/UpdateCustomer",
                data: '{customerId: ' + customerId + ', name: "' + name + '", country: "' + country + '" }',
                contentType: "application/json; charset=utf-8",
                dataType: "json"
            });

            return false;
        });

        //Cancel event handler.
        $("body").on("click", "[id*=gvCustomers] .Cancel", function () {
            var row = $(this).closest("tr");
            $("td", row).each(function () {
                if ($(this).find("input").length > 0) {
                    var span = $(this).find("span");
                    var input = $(this).find("input");
                    input.val(span.html());
                    span.show();
                    input.hide();
                }
            });
            row.find(".Edit").show();
            row.find(".Delete").show();
            row.find(".Update").hide();
            $(this).hide();
            return false;
        });

        //Delete event handler.
        $("body").on("click", "[id*=gvCustomers] .Delete", function () {
            if (confirm("Do you want to delete this row?")) {
                var row = $(this).closest("tr");
                var customerId = row.find("span").html();
                $.ajax({
                    type: "POST",
                    url: "DOM.aspx/DeleteCustomer",
                    data: '{customerId: ' + customerId + '}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        if ($("[id*=gvCustomers] tr").length > 2) {
                            row.remove();
                        } else {
                            row.find(".Edit").hide();
                            row.find(".Delete").hide();
                            row.find("span").html('&nbsp;');
                        }
                    }
                });
            }

            return false;
        });
    </script>
    </form>
</body></center>
</html>
