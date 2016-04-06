<%include file="header.html"/>
<div class="container"  style="padding-top:50px">
    <div class="row" style="padding-top:20px">
        <div class="col-lg-12">
            <div class="panel panel-default">
                <div class="panel-heading">
                    <i class="fa fa-info fa-fw"></i> Groups
                </div>

                <div class="input-group"><span class="input-group-addon"> <i class="fa fa-search fa-fw"></i></span>
                    <input id="filter" type="text" class="form-control" placeholder="Type here...">
                </div>
                <table class="table table-hover table-bordered table-striped sortable" id="node-table">
                    <thead>
                    <tr>
<%
titles = ('Name', 'Enabled','Default', 'Time From', 'Time To', 'Days', 'Repeats', 'Date From','Clear Scheduling', 'Save')
%>
                        % for i in titles:
                            <th data-field="${i}">${i}</th>
                        % endfor
                    </tr>
                    </thead>
                    <tbody class="searchable rows">
                        % for group in groups:
                        <tr class="clickable-row" data-id="${group.id}">
                            <td><a href="/group/${group.id}">${group.name}</a></td>
                            <%
                                    checked = ""
                                    if group.enabled:
                                        checked = "checked"
                                %>
                            <td><input data-id="${group.id}" class="enabler" type="checkbox" ${checked}/></td>
                             <%
                                    checked = ""
                                    if group.default:
                                        checked = "checked"
                                %>
                            <td><input data-id="${group.id}" type="radio" ${checked} /></td>
                            <td>
                                <div class="form-group">
                                    <div class='input-group date time_' >
                                        <input type='text' class="form-control" id='time_from' value="${group.time_from} " />
                                        <span class="input-group-addon">
                                            <i class="fa fa-clock-o"></i>
                                        </span>
                                    </div>
                                </div>
                            </td>
                            <td>
                                <div class="form-group">
                                    <div class='input-group date time_'>
                                        <input type='text' class="form-control" id='time_to' value="${group.time_to}" />
                                        <span class="input-group-addon">
                                            <i class="fa fa-clock-o"></i>
                                        </span>
                                    </div>
                                </div>
                            </td>
                            <td width="150px">
                            %for idx,i in enumerate(['Mo','Tu','We','Th','Fr','Sa','Su']):
<%
                                    checked = ""
                                    if group.days_of_week is not None and group.days_of_week[idx] == '1':
                                        checked = "checked"
                                %>${i} <input type="checkbox"  name="day_${idx}" ${checked} />
                            %endfor
                            </td>
                                <%
                                  repeats = ""
                                  if group.repeats is not None:
                                    repeats = "value={}".format(group.repeats)
                                %>
                            <td><input type="number" min="0" id="repeats" style="width:40px" ${repeats} /></td>
                            <td>
                                <div class="form-group">
                                    <div class='input-group date' >
                                        <%
                                            date_from = ""
                                            if group.date_from is not None:
                                                date_from = 'value="'+(group.date_from.strftime("%d/%m/%Y"))+'"'
                                            %>
                                        <input type='text' class="form-control date_from" ${date_from|n} />
                                        <span class="input-group-addon">
                                            <i class="fa fa-calendar"></i>
                                        </span>
                                    </div>
                                </div>
                            </td>

                            <td><button name="special" class="btn btn-warning clear-event">Clear</button></td>
                            <td><button data-id="${group.id}" class="save btn btn-primary">Save</button></td>

                        % endfor
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-12">
            <div class="panel panel-default">
                <div class="panel-heading">
                    <i class="fa fa-info fa-fw"></i> New Group
                </div>
                <div class="panel-body">
                    New group form right here
                </div>
            </div>
        </div>
    </div>
</div>
<script>
$('#new-group-form').submit(function(e) {
    e.preventDefault();
        $("#submit-message").hide(300);
        console.log("posting");
        $.post('/',{
            source: $("#inputSource").val(),
            name: $("#inputName").val(),
            length: $("#inputLength").val()
        }, function(data) {
            console.log("posted");
            if (data.hasOwnProperty('error')) {
                $('#submit-message').text(data.error).show(300);
            } else {
                window.location.reload(true);
            }
        });
});
$('.save').click(function() {
    var row = $(this).parent().parent();
    var checked = row.find('input:checkbox').first().is(':checked');
    // update the plugin
    var id = $(this).data('id');
    var days = [];
    row.find('input[name^="day_"]').each(function () {
        days.push($(this).is(':checked')? '1': '0');
    });
    days = days.join("");
    var data = {
        enabled: checked,
        time_from: row.find('#time_from').val(),
        time_to: row.find('#time_to').val(),
        days:days,
        repeats:row.find('#repeats').val(),
        date_from: row.find('.date_from').val(),
    };
    console.log(data);
    $.post('/plugin/'+id, data,function(data) {
        console.log(data);
    });
});
$()
$(function () {
    $('.time_').datetimepicker({format:'HHmm'});
    $('.date_from').datetimepicker({format:'D/MM/YYYY'});
});
    $('.clear-event').click(function() {
        $(this)
                .parent()
                .siblings()
                .find('input')
                .slice(2)
                .not(':button, :submit, :reset, :hidden')
                .val('')
                .removeAttr('checked')
                .removeAttr('selected');
    });

</script>

<%include file="footer.html"/>