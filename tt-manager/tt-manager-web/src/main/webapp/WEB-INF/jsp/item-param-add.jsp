<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="utf-8" %>
<div class="easyui-panel" title="商品规格参数模板详情" data-options="fit:true">
    <form class="form" id="itemParamAddForm" name="itemParamAddForm" method="post">
        <table style="width: 100%">
            <tr>
                <td class="label">商品类目:</td>
                <td>
                    <input id="cid" name="cid" style="width: 200px;">
                </td>
            </tr>
            <tr>
                <td class="label">规格参数:</td>
                <td>
                    <button class="easyui-linkbutton" onclick="addGroup()" type="button" data-options="iconCls:'icon-add'">添加分组</button>
                    <ul id="item-param-group">

                    </ul>
                    <ul id="item-param-group-template" style="display: none;">
                        <li>
                            <input name="group">
                            <button title="添加参数" class="easyui-linkbutton" onclick="addParam(this)" type="button" data-options="iconCls:'icon-add'"></button>
                            <button title="删除分组" class="easyui-linkbutton" onclick="delGroup(this)" type="button" data-options="iconCls:'icon-cancel'"></button>
                            <ul class="item-param">
                                <li>
                                    <input name="param">
                                    <button title="删除参数" class="easyui-linkbutton" onclick="delParam(this)" type="button" data-options="iconCls:'icon-cancel'"></button>
                                </li>
                            </ul>
                        </li>
                    </ul>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <button class="easyui-linkbutton" onclick="submitForm()" type="button" data-options="iconCls:'icon-ok'">保存</button>
                    <button class="easyui-linkbutton" onclick="clearForm()" type="button" data-options="iconCls:'icon-undo'">重置</button>
                </td>
            </tr>
        </table>
    </form>
</div>

<script>
    //初始化类别选择树
    $('#cid').combotree({
        url:'itemCats?parentId=0',
        required:true,
        //请求方式
        method:'get',
        onBeforeExpand:function (node) {
            //获取当前被点击的tree
            var $tree = $('#cid').combotree('tree');
            //调用easyui tree组件的options方法
            var option = $tree.tree('options');
            //修改option的url属性
            option.url = 'itemCats?parentId=' + node.id;
        },
        onBeforeSelect:function (node) {
            var isLeaf = $('#cid').tree('isLeaf',node.target);
            if(!isLeaf){
                $.messager.alert('警告','请选择最终类目','warning');
                return false;
            }
        }
    });

    //添加分组
    function addGroup() {
        var $templateLi = $('#item-param-group-template li').eq(0).clone();
        $('#item-param-group').append($templateLi);
    }
    //添加参数
    function addParam(ele) {
        var $paramLi = $('#item-param-group-template .item-param li').eq(0).clone();
        $(ele).parent().find('.item-param').append($paramLi);
    }
    //删除参数
    function delParam(ele) {
        $(ele).parent.remove();
    }
    //删除分组
    function delGroup(ele) {
        $(ele).parent().remove();
    }
    //提交
    function submitForm() {
        //创建空数组
        var groupValues = [];
        var $groups = $('#item-param-group [name=group]');
        //拼接需要保存的JSON字符串
        $groups.each(function (i,e) {
            //i是索引号，e是当前DOM对象
            var paramsValues = [];
            var $params = $(e).parent().find('.item-param [name=param]');
            $params.each(function (_i,_e) {
                //_i是索引号，_e是当前DOM对象
                var _val = $(_e).val();
                if($.trim(_val).length>0){
                    paramsValues.push(_val);
                }//["参数1","参数2"]
            });
            var obj = {};
            var val = $(e).val();
//            console.log(e);
//            console.log($(e));
//            console.log($(e).val());
            obj.group = val;
            obj.params = paramsValues;
            if($.trim(val).length>0 && paramsValues.length>0){
                groupValues.push(obj);
            }
        });
        //3 发送异步请求
        $.post(
            'itemParam/' + $('#cid').combotree('getValue'),
            {'paramData':JSON.stringify(groupValues)},
            function (data) {
                if(data>0){
                    ttshop.closeTab('新增规格参数');
                    ttshop.closeTab('查询规格参数');
                    ttshop.addTab('查询规格参数','item-param-list');
                    $.messager.alert('温馨提示','参数规格添加成功!','info');
                }else{
                    $.messager.alert('警告','未添加参数','warning');
                }
            }
        );
    }
</script>
