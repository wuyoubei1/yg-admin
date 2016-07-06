<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<script type="text/javascript">
function changeZtree(t) {
    var $panel = $.CurrentNavtab
    var $t     = $('#ztree1'),
        $span  = $('#ztree-'+ t),
        $log   = $('#ztree-log'),
        op     = $t.data()
    
        
    $t.data('maxAddLevel', 4);
        
    if (t != 7)
        $.fn.zTree.destroy('ztree1')
    
    switch(t) {
        case 1:
            var edit   = op.showRenameBtn ? false : true,
                rename = op.showRenameBtn ? false : true,
                remove = op.showRemoveBtn ? false : true
                
            $t.data('editEnable', edit).data('showRenameBtn', rename).data('showRemoveBtn', remove)
            
            $log.val('data-edit-enable="'+ edit +'"\r\n' + 'data-show-rename-btn="'+ rename +'"\r\n' + 'data-show-remove-btn="'+ remove +'"')
            $span.text(($span.text() == '无') ? '显示' : '无')
            break
        case 2:
            var add    = op.addHoverDom ? null : 'edit',
                remove = op.removeHoverDom ? null : 'edit'
               	bDrag  = op.beforeDrag ? '' : 'M_BeforeNodeDrag',
                bDrop  = op.beforeDrop ? '' : 'M_BeforeNodeDrop',
                onDrop = op.onDrop ? '' : 'M_NodeDrop'
                				
            $t.data('addHoverDom', add).data('removeHoverDom', remove).data('beforeDrop', bDrop).data('beforeDrag', bDrag)
            
            $log.val('data-add-hover-dom="'+ add +'"\r\n' + 'data-remove-hover-dom="'+ remove +'"')
            $span.text(($span.text() == '无') ? '显示' : '无')
            break
        case 3:
            var check = op.checkEnable ? false : true
            
            $t.data('checkEnable', check)
            
            $log.val('data-check-enable="'+ check +'"')
            $span.text(($span.text() == '无') ? '显示' : '无')
            break
        case 4:
            var edit   = op.editEnable ? true : true,
                bDrag  = op.beforeDrag ? '' : 'M_BeforeNodeDrag',
                bDrop  = op.beforeDrop ? '' : 'M_BeforeNodeDrop',
                onDrop = op.onDrop ? '' : 'M_NodeDrop'
            
            $t.data('editEnable', edit).data('beforeDrag', bDrag).data('beforeDrop', bDrop).data('onDrop', onDrop)
            
            $log.val('data-edit-enable="'+ edit +'"\r\n' + 'data-before-drag="'+ bDrag +'"\r\n' + 'data-before-drop="'+ bDrop +'"\r\n' + 'data-on-drop="'+ onDrop +'"')
            $span.text(($span.text() == '无') ? 'M_BeforeNodeDrag、M_BeforeNodeDrop、M_NodeDrop' : '无')
            break
        case 5:
            var add    = op.beforeRemove ? null : 'edit',
                remove = op.beforeRemove ? null : 'edit',
                bR     = op.beforeRemove ? null : 'M_BeforeRemove'
                oR     = op.onRemove ? null : 'M_NodeRemove'
            
            $t.data('addHoverDom', add).data('removeHoverDom', remove).data('beforeRemove', bR).data('onRemove', oR)
            
            $log.val('data-add-hover-dom="'+ add +'"\r\n' + 'data-remove-hover-dom="'+ remove +'"\r\n' + 'data-before-remove="'+ bR +'"\r\n' + 'data-on-remove="'+ oR +'"')
            $('#ztree-2').text(($('#ztree-2').text() == '无') ? '显示' : '无')
            $span.text(($span.text() == '无') ? 'M_BeforeRemove、M_NodeRemove' : '无')
            break
        case 6:
            var diy = op.addDiyDom ? null : 'M_AddDiyDom'
            
            $t.data('addDiyDom', diy)
            
            $log.val('data-add-diy-dom="'+ diy +'"')
            $span.text(($span.text() == '无') ? 'M_AddDiyDom' : '无')
            break
        case 7:
            var tree = $.fn.zTree.getZTreeObj("ztree1")
            var menus = tree.getNodes()
            $log.val(JSON.stringify(menus))
            break
    }
    $panel.initui()
}
//单击事件
function ZtreeClick(event, treeId, treeNode) {
    event.preventDefault()
    
    //获取父节点
    var treeObj = $.fn.zTree.getZTreeObj("ztree1");
	var node = treeObj.getNodeByTId(treeNode.parentTId);
    if(null==node){
    	return ;
    }
    var $detail = $('#ztree-detail')
    
    if ($detail.attr('tid') == treeNode.tId) return
	if (treeNode.name) {
		$('#j_menu_name').val(treeNode.name);
		$('#id').val(treeNode.id);
		$('#pname').val(node.name);
		$('#pid').val(node.id);
	}
	/**获取菜单的排列顺序
	if(treeNode.id){
		var url="menu/getMenuSort/"+treeNode.id;
		$(this).bjuiajax('doAjax', {url:url,callback:function(json){
			$('#j_menu_sort').val(json.sort);
		}})
	}**/
	//alert(url);
	$detail.attr('tid', treeNode.tId)
    $detail.show()
}
//保存属性
function M_Ts_Menu() {
	var zTree  = $.fn.zTree.getZTreeObj("ztree1")
	var name   = $('#j_menu_name').val()
	var tabid  = $('#j_menu_tabid').val()
	var target = $('#j_menu_target').val()
	
	if ($.trim(name).length == 0) {
		alertMsg.error('菜单名称不能为空！')
		return;
	}
	var upNode = zTree.getSelectedNodes()[0]
	
	if (!upNode) {
		alertMsg.error('未选中任何菜单！')
        return
	}
	upNode.name   = name
	upNode.tabid  = tabid
	upNode.target = target
	zTree.updateNode(upNode);
	
	$(form).bjuiajax('ajaxForm', null);
}
//
function M_BeforeNodeDrag(treeId, treeNodes) {
    var $log = $('#ztree-log')
    $log.val('开始拖拽：'+ treeNodes[0].name +'！\n'+ $log.val())
    return true
}
//监听拖拽事件
function M_BeforeNodeDrop(treeId, treeNodes, targetNode, moveType, isCopy) {
    /*禁止插入层级为4的节点*/
    if (moveType == 'inner' && targetNode.level == 4) {
        return false
    }
    /*禁止插入剩余层级不足的子节点*/
    if (moveType == 'inner' && treeNodes[0].isParent) {
        var molevel = 4 - targetNode.level //剩余层级
        var maxlevel = 1
        var zTree = $.fn.zTree.getZTreeObj("ztree1")
        var nodes = zTree.transformToArray(treeNodes)
        var level = nodes[0].level
        
        for (var i = 1; i < nodes.length; i++) {
            if (nodes[i].level == (level + 1)) {
                maxlevel++
                level++
            }
        }
        if (maxlevel > molevel) {
            return false
        }
    }
    return true
}
//拖拽结束事件
function M_NodeDrop(event, treeId, treeNodes, targetNode, moveType, isCopy) {
    var $log = $('#ztree-log')
    $log.val('拖拽结束！\n'+ $log.val())
}
//删除前事件
function M_BeforeRemove(treeId, treeNode) {
    var $log = $('#ztree-log')
    $log.val('准备删除：'+ treeNode.name +'！\n'+ $log.val())
    return true
}
//删除结束事件
function M_NodeRemove(event, treeId, treeNode) {
	//alert(treeNode.id);
    var $log = $('#ztree-log')
    //$(form).bjuiajax('ajaxForm', null);
    var url="menu/delete/"+treeNode.id;
    //alert(url);
    $('#updateBtn').bjuiajax('doAjax', {url:url})
    $log.val('删除成功！\n'+ $log.val())
}
//自定义DOM
function M_AddDiyDom(treeId, treeNode) {
    var aObj = $('#' + treeNode.tId + '_a')
    
	if ($('#diyBtn_'+ treeNode.id).length > 0) return
	aObj.append('<button type="button" class="diyBtn1" id="diyBtn_' + treeNode.id +'" title="'+ treeNode.name +'" onfocus="this.blur();"><i class="fa fa-plane"></i></button>')
	$('#diyBtn_'+ treeNode.id).bind('click', function() {$(this).alertmsg('info', (treeNode.name +' 的飞机！'))})
}
function returnJSON() {
    return [{"id":1,"pid":0,"faicon":"rss","faiconClose":"cab","name":"表单元素","level":0,"tId":"ztree1_1","parentTId":null,"open":false,"isParent":false,"zAsync":true,"isFirstNode":true,"isLastNode":false,"isAjaxing":false,"checked":false,"checkedOld":false,"nocheck":false,"chkDisabled":false,"halfCheck":false,"check_Child_State":-1,"check_Focus":false,"isHover":false,"editNameFlag":false},{"id":10,"pid":1,"url":"form-button.html","tabid":"form-button","faicon":"bell","pId":1,"name":"按钮","level":0,"tId":"ztree1_2","parentTId":null,"open":false,"isParent":false,"zAsync":true,"isFirstNode":false,"isLastNode":false,"isAjaxing":false,"checked":false,"checkedOld":false,"nocheck":false,"chkDisabled":false,"halfCheck":false,"check_Child_State":-1,"check_Focus":false,"isHover":false,"editNameFlag":false},{"id":11,"pid":1,"url":"form-input.html","tabid":"form-input","faicon":"info-circle","pId":1,"name":"文本框","level":0,"tId":"ztree1_3","parentTId":null,"open":false,"isParent":false,"zAsync":true,"isFirstNode":false,"isLastNode":false,"isAjaxing":false,"checked":false,"checkedOld":false,"nocheck":false,"chkDisabled":false,"halfCheck":false,"check_Child_State":-1,"check_Focus":false,"isHover":false,"editNameFlag":false},{"id":12,"pid":1,"url":"form-select.html","tabid":"form-select","faicon":"ellipsis-v","pId":1,"name":"下拉选择框","level":0,"tId":"ztree1_4","parentTId":null,"open":false,"isParent":false,"zAsync":true,"isFirstNode":false,"isLastNode":false,"isAjaxing":false,"checked":false,"checkedOld":false,"nocheck":false,"chkDisabled":false,"halfCheck":false,"check_Child_State":-1,"check_Focus":false,"isHover":false,"editNameFlag":false},{"id":13,"pid":1,"url":"form-checkbox.html","tabid":"table","faicon":"soccer-ball-o","pId":1,"name":"复选、单选框","level":0,"tId":"ztree1_5","parentTId":null,"open":false,"isParent":false,"zAsync":true,"isFirstNode":false,"isLastNode":false,"isAjaxing":false,"checked":false,"checkedOld":false,"nocheck":false,"chkDisabled":false,"halfCheck":false,"check_Child_State":-1,"check_Focus":false,"isHover":false,"editNameFlag":false},{"id":14,"pid":1,"url":"form.html","tabid":"form","faicon":"comments","pId":1,"name":"表单综合演示","level":0,"tId":"ztree1_6","parentTId":null,"open":false,"isParent":false,"zAsync":true,"isFirstNode":false,"isLastNode":false,"isAjaxing":false,"checked":false,"checkedOld":false,"nocheck":false,"chkDisabled":false,"halfCheck":false,"check_Child_State":-1,"check_Focus":false,"isHover":false,"editNameFlag":false},{"id":2,"pid":0,"name":"表格","level":0,"tId":"ztree1_7","parentTId":null,"open":false,"isParent":false,"zAsync":true,"isFirstNode":false,"isLastNode":false,"isAjaxing":false,"checked":false,"checkedOld":false,"nocheck":false,"chkDisabled":false,"halfCheck":false,"check_Child_State":-1,"check_Focus":false,"isHover":false,"editNameFlag":false},{"id":20,"pid":2,"url":"table.html","tabid":"table","faicon":"signal","pId":2,"name":"普通表格","level":0,"tId":"ztree1_8","parentTId":null,"open":false,"isParent":false,"zAsync":true,"isFirstNode":false,"isLastNode":false,"isAjaxing":false,"checked":false,"checkedOld":false,"nocheck":false,"chkDisabled":false,"halfCheck":false,"check_Child_State":-1,"check_Focus":false,"isHover":false,"editNameFlag":false},{"id":21,"pid":2,"url":"table-fixed.html","tabid":"table-fixed","faicon":"rss-square","pId":2,"name":"固定表头表格","level":0,"tId":"ztree1_9","parentTId":null,"open":false,"isParent":false,"zAsync":true,"isFirstNode":false,"isLastNode":false,"isAjaxing":false,"checked":false,"checkedOld":false,"nocheck":false,"chkDisabled":false,"halfCheck":false,"check_Child_State":-1,"check_Focus":false,"isHover":false,"editNameFlag":false},{"id":22,"pid":2,"url":"table-edit.html","tabid":"table-edit","faicon":"bookmark-o","pId":2,"name":"可编辑表格","level":0,"tId":"ztree1_10","parentTId":null,"open":false,"isParent":false,"zAsync":true,"isFirstNode":false,"isLastNode":true,"isAjaxing":false,"checked":false,"checkedOld":false,"nocheck":false,"chkDisabled":false,"halfCheck":false,"check_Child_State":-1,"check_Focus":false,"isHover":false,"editNameFlag":false}]
}
</script>
<div class="bjui-pageContent">
    <div style="padding:0px;">
        <div class="clearfix">
            <div style="float:left; width:350px; height:500px; overflow:auto;">
                <ul id="ztree1" class="ztree" data-toggle="ztree" maxAddLevel=4
                    data-options="{
                        expandAll: true,
                        onClick: 'ZtreeClick'
                    }"
                >
                <!-- 拼接树 -->
                <c:forEach items="${types }" var="menu" varStatus="status">
                	<li data-id="${menu.id }" data-pid="${menu.pid }" 
                		data-faicon="rss" data-faicon-close="cab"
                		data-url="">${menu.name }</li>
                </c:forEach>
                    
                </ul>
            </div>
            &nbsp;&nbsp;
            <button type="button" class="btn btn-green" onclick="changeZtree(5);">维护</button>
            <a class="btn btn-orange" href="javascript:;" onclick="BJUI.navtab('refresh','');" data-icon="undo">刷新</a>
            <div id="ztree-detail" style="display:none; margin-left:355px; width:300px; height:240px;">
            <form action="${ctx }/productType/saveOrUpdate.do" data-toggle="ajaxform">
            	<input type="hidden" id="id" name="id" value=0>
            	<input type="hidden" id="pid" name="pid" value="">
                <div class="bs-example" data-content="详细信息">
                	<div class="form-group">
                        <label for="j_menu_name" class="control-label x85">父类名称：</label>
                        <input type="text" class="form-control validate[required] required" name="m.pname" id="pname" size="20" placeholder="父菜单名称" readonly="readonly"/>
                    </div>
                	
                    <div class="form-group">
                        <label for="j_menu_name" class="control-label x85">分类名称：</label>
                        <input type="text" class="form-control validate[required] required" name="name" id="j_menu_name" size="20" placeholder="名称" />
                    </div>
                    <div class="form-group">
                        <label for="j_menu_sort" class="control-label x85">排序：</label>
                        <input type="text" class="form-control validate[required] required" name="sort" id="j_menu_sort" size="20" placeholder="100" />
                    </div>
                    <div class="form-group" style="padding-top:8px; border-top:1px #DDD solid;">
                        <label class="control-label x85"></label>
                        <button id="updateBtn" class="btn btn-green" onclick="M_Ts_Menu();">更新菜单</button>
                    </div>
                </div>
                <div class="clearfix" style="margin-top:20px;">
		            <div style="float: left; width: 220px;">
		                <p><label class="control-label x120">默认编辑删除按钮：</label><span id="ztree-1" class="label label-default">无</span></p>
		                <p><label class="control-label x120">自定义添/删按钮：</label><span id="ztree-2" class="label label-default">无</span></p>
		                <p><label class="control-label x120">复选框：</label><span id="ztree-3" class="label label-default">无</span></p>
		                <p><label class="control-label x120">拖拽事件：</label><span id="ztree-4" class="label label-default">无</span></p>
		                <p><label class="control-label x120">删除事件：</label><span id="ztree-5" class="label label-default">无</span></p>
		                <p><label class="control-label x120">自定义DOM：</label><span id="ztree-6" class="label label-default">无</span></p>
		            	<textarea style="width:400px; font-size:12px;" rows="5" id="ztree-log"></textarea>
		            </div>
		        </div>
		    </form>
            </div>
        </div>
    </div>
</div>
<div class="bjui-pageFooter">
    <ul>
        <li><button type="button" class="btn-close" data-icon="close">关闭</button></li>
    </ul>
</div>