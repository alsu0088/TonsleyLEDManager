<%include file="header.html"/>

<div class="container" style="padding-top:50px">
    <div class="row" style="padding-top:20px">
        <div class="col-lg-6">
            <div class="panel panel-default">
                <div class="panel-heading">
                    <i class="fa fa-info fa-fw"></i> My Plugins
                </div>
                <table class="table table-hover table-bordered table-striped sortable" id="node-table">
                    <thead>
                    <tr>
                        % for i in  ('Name', 'Author', 'Save'):
                            <th data-field="${i}">${i}</th>
                        % endfor
                    </tr>
                    </thead>
                    <tbody class="searchable rows">
                        % for plugin in plugins:
                            <tr class="clickable-row" data-id="${plugin.id}">
                                <td>${plugin.name}</td>
                                <td><a href="/users/${plugin.user_id}">${plugin.user.email.split('@')[0]}</a></td>
                                <td><button data-id="${plugin.id}" class="save btn btn-primary">Save</button></td>
                            </tr>
                        %endfor
                    </tbody>
                </table>
            </div>
        </div>
        <div class="col-lg-6">
        <div class="row">
            <div class="panel panel-default">
                <div class="panel-heading">
                    <i class="fa fa-info fa-fw"></i> New Plugin
                </div>
                <div class="panel-body">
                    <form class="form-horizontal" id="new-plugin-form">
                        <div class="form-group">
                            <label for="inputEmail3" class="col-sm-2 control-label">Name</label>
                            <div class="col-sm-10">
                                <input type="text" class="form-control" name="name" id="inputName"
                                       placeholder="Plugin Name">
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="inputLength" class="col-sm-2 control-label">Source</label>
                            <div class="col-sm-10">
                                    <textarea class="form-control" id="inputSource" name="source"
                                              placeholder="while 1: print 1"></textarea>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="col-sm-offset-2 col-sm-10">
                                <button type="submit" name="form.submitted" class="btn btn-default">Add</button>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="col-sm-offset-2 col-sm-10">
                                <div style="display: none" id="submit-message" class="alert alert-danger"
                                     role="alert">Error
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
    </div>

    <div class="row">
    <div class="col-lg-12" id="code-preview">
            <div class="panel panel-default">
                <div class="panel-heading">
                    <i class="fa fa-info fa-fw"></i> Source
                </div>
                <div class="panel-body">
                    <textarea id="code" class="form-control"></textarea>
                </div>
            </div>
        </div></div>
</div>
<%include file="codemirror.mako"/>
<%include file="footer.html"/>
