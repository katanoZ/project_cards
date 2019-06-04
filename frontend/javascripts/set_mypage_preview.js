window.addEventListener('DOMContentLoaded', setMyPagePreview);

//マイページの画像ファイル選択時にプレビューを表示
function setMyPagePreview(){
  const myPageFileField = document.querySelector('#js-mypage_filefield');
  if (myPageFileField === null) {　return; }

  myPageFileField.addEventListener('change', () => {
    const inputFile = document.querySelector('#js-mypage_filefield').files[0];

    //画像のみ処理
    const IMAGE_TYPE = /image.*/;
    if (!inputFile.type.match(IMAGE_TYPE)) {
      return;
    }

    //プレビュー画像を表示
    const reader = new FileReader();
    reader.readAsDataURL(inputFile);
    reader.onload = function(){
      const myPageImage = document.querySelector('#js-mypage_image');
      myPageImage.setAttribute('src', reader.result);
    };
  });
};
