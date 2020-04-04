// 勤怠申請モーダルの値渡し
    $(document).ready(function() {
    $('#modal1').on('show.bs.modal', function (event) {
      var button = $(event.relatedTarget) //モーダルを呼び出すときに使われたボタンを取得
      var date = button.data('date') //data-date の値を取得
      var day = button.data('day') //data-day の値を取得
      var date_1 = button.data('date_1') //data-date_1 の値を取得
      
      //Ajaxの処理はここに
    
      var modal = $(this)  //モーダルを取得
      modal.find('#modal-date').text(date) //モーダルの日付に値を表示
      modal.find('#modal-day').text(day) //モーダルの曜日に値を表示
      modal.find('#test').val(date_1)
      
      
    })
    });



// ユーザーの勤怠確認後、リンクバック後の該当勤怠のモーダル再表示
    $(document).ready(function() {
        $(window).load(function () {
        // 実行したい処理
        var arg  = new Object;
     url = location.search.substring(1).split('&');
     
    for(i=0; url[i]; i++) {
        var k = url[i].split('=');
        arg[k[0]] = k[1];
    }
     
    var params = arg.modal
    console.log(params)
        if(params=="over_work"){
     //条件に合う時の処理
         $('#over_work')[0].click();
     }
        if(params=="month"){
     //条件に合う時の処理
         $('#month')[0].click();
     }
        if(params=="change_work"){
     //条件に合う時の処理
         $('#change_work')[0].click();
     }
        });
    });

// 該当勤怠にクラスを付与
    $(document).ready(function() {
        // 実行したい処理
        var arg  = new Object;
     url = location.search.substring(1).split('&');
     
    for(i=0; url[i]; i++) {
        var k = url[i].split('=');
        arg[k[0]] = k[1];
    }
    var params = arg.work_day
    console.log(params)
     //条件に合う時の処理
         $('#'+ params).attr('class', 'warning');
        });


// 自動スクロール
    $(document).ready(function() {
    window.onload = function() {
        $('html,body').animate({scrollTop:($('.warning').offset().top)-500});
        return false;
    };
     });