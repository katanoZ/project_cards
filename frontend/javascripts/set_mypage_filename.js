window.addEventListener('DOMContentLoaded', setMyPageFileName);

//ファイル選択時に、ファイル選択ボタンにファイル名を表示
function setMyPageFileName(){
  const myPageFileField = document.getElementById('js-mypage_filefield');
  if (myPageFileField === null) { return; }

  myPageFileField.addEventListener('change', () => {
    const newFileNameText = document.getElementById('js-mypage_filefield').files[0].name;
    const fileName = document.getElementById('js-mypage_filename');
    fileName.textContent = newFileNameText;
  });
};
