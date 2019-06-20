window.addEventListener('DOMContentLoaded', previewImage);

//画像ファイル選択時にプレビューを表示
function previewImage(){
  const fileField = document.getElementById('js-filefield');

  fileField.addEventListener('change', () => {
    const inputFile = document.getElementById('js-filefield').files[0];

    //画像のみ処理
    const IMAGE_TYPE = /image.*/;
    if (!inputFile.type.match(IMAGE_TYPE)) { return; }

    //プレビュー画像を表示
    const reader = new FileReader();
    reader.readAsDataURL(inputFile);
    reader.onload = () => {
      const image = document.getElementById('js-image');
      image.setAttribute('src', reader.result);
    };
  });
};
