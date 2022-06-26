function doGet(e: GoogleAppsScript.Events.DoGet) {
  let returnObject = {}

  if (e.parameter.foo === "bar") {
    returnObject = { hello: "world" }
  } else {
    returnObject = { goodbye: "world" }
  }

  // この return は決まり文句
  return ContentService.createTextOutput(JSON.stringify(returnObject, null, 2)).setMimeType(ContentService.MimeType.JSON);
}

function doPost(e: GoogleAppsScript.Events.DoPost) {
  if (e === null || e.postData === null || e.postData.contents === null) {
    return
  }

  const postData = JSON.parse(e.postData.contents)

  const missingTweetsSheet = ZzzConcerns.changeActiveSheetTo('APIテスト')
  const firstKey = Object.keys(postData)[0]
  missingTweetsSheet.getRange(3, 4, 1, 1).setValue(postData[firstKey])
}

// リクエストをモックしたテストコード (GET)
function doGetTest() {
  const e: any = {
    parameter: {
      foo: 'bar'
    }
  }

  doGet(e)
}

// リクエストをモックしたテストコード (POST)
function doPostTest() {
  const e: any = {
    postData: {
      type: 'application/json',
      contents: "{\"key1\":100, \"key2\":\"文字列\"}"
    }
  }

  doPost(e)
}
