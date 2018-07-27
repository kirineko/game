$(document).on("click", "#task-get", function () {
    $.get('/task', function (data) {
        let ctask = data['data'];
        let code = data['code'];
        if(code == -1) {
            YDUI.dialog.alert('扑克牌已经分配完了，请清空后重新分配');
            return;
        }
        $('#maxid').html(ctask.task_id);
        let v_ctask = $('#ctask b')
        $(v_ctask[0]).html(ctask.task_id);
        $(v_ctask[1]).html(ctask.color);
        $(v_ctask[2]).html(ctask.point);
        $(v_ctask[3]).html(ctask.content);

        let tab = $('#history');
        tab.prepend($('<div class="m-cell">').append(
            $('<div class="cell-item">').append(
                $('<div class="cell-left">').html("任务编号:"),
                $('<div class="cell-right">').html(ctask.task_id)
            ),
            $('<div class="cell-item">').append(
                $('<div class="cell-left">').html("花色:"),
                $('<div class="cell-right">').append(
                    $('<b>').html(ctask.color)
                )
            ),
            $('<div class="cell-item">').append(
                $('<div class="cell-left">').html("点数:"),
                $('<div class="cell-right">').append(
                    $('<b>').html(ctask.point)
                )
            ),
            $('<div class="cell-item">').append(
                $('<div class="cell-left">').html("任务:"),
                $('<div class="cell-right">').append(
                    $('<b>').html(ctask.content)
                )
            )
        ))
    });
})

$(document).on("click", "#task-clear", function () {
    $.get('/clear', function (data) {
        let code = data['code'];
        if (code == 0) {
            $('#maxid').html(0);
            $('#history').html('');
            $('#ctask b:even').each(function () {
                $(this).html('0');
            })
            $('#ctask b:odd').each(function () {
                $(this).html('待定');
            })
        }
    });
})
