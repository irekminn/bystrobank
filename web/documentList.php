<?php

require_once("../conf/bootstrap.php");

//читаем данные и HTTP-запроса, строим из них XML по схеме
$hreq = new HTTP_Request2Xml("schemas/TestApp/DocumentListRequest.xsd");
$req=new TestApp_DocumentListRequest();
if (!$hreq->isEmpty()) {
	$hreq->validate();
	$req->fromXmlStr($hreq->getAsXML());
}

// формируем xml-ответ
$xw = new XMLWriter();
$xw->openMemory();
$xw->setIndent(TRUE);
$xw->startDocument("1.0", "UTF-8");
$xw->writePi("xml-stylesheet", "type=\"text/xsl\" href=\"stylesheets/TestApp/DocumentList.xsl\"");
$xw->startElementNS(NULL, "DocumentListResponse", "urn:ru:ilb:meta:TestApp:DocumentListResponse");
$req->toXmlWriter($xw);
// Если есть входные данные, проведем вычисления и выдадим ответ
if (!$hreq->isEmpty()) {
	$pdo=new PDO("mysql:host=192.168.56.10;dbname=testapp","testapp","1qazxsw2",array(PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION));
	//prior to PHP 5.3.6, the charset option was ignored. If you're running an older version of PHP, you must do it like this:
	//$pdo->exec("set names utf8");
	if (isset($req->docName) && !empty($req->docName) && $req->searchNoDate){
			$query = "SELECT * FROM document WHERE displayName LIKE :docName";
			$paramsQuery = array(":docName"=>"%{$req->docName}%");
	}else{
			$query = "SELECT * FROM document WHERE docDate BETWEEN :dateStart AND :dateEnd";
			$paramsQuery = array(":dateStart"=>$req->dateStart,":dateEnd"=>$req->dateEnd);
		}
	$sth=$pdo->prepare($query);
	$sth->execute($paramsQuery);

	while($row=$sth->fetch(PDO::FETCH_ASSOC)) {
		$strtoLower = mb_convert_case($row['displayName'], MB_CASE_LOWER, "UTF-8");
		if (isset($req->docName) && !empty($req->docName) && $req->searchNoDate===NULL) {
			if (strpos($strtoLower, mb_convert_case($req->docName, MB_CASE_LOWER, "UTF-8")) === FALSE) continue;
		}
		$doc = new TestApp_Document();
		//Добавляем в $row link на документ
		if ( isset($row['objectId']) && !empty( $row['objectId'] ) ){
			$linkDocument = '/'. $_SERVER['SERVER_NAME']. '/testapp/web/document.php?objectId='.$row['objectId'];
			$row['linkDocument'] = $linkDocument;
		}

		$doc->fromArray($row);
		$doc->toXmlWriter($xw);
	}
}
$xw->endElement();
$xw->endDocument();

//Вывод ответа клиенту
if ( $req->outputFormat == 'pdf' ) {

	$attachmentName = "documentsList.pdf";
    $headers = array(
		"Content-Type: application/pdf",
		"Content-Disposition: inline; filename*=UTF-8''" . $attachmentName
	);
	foreach ($headers as $h) {
			header($h);
		}

	$fo = $req->transformFo($xw);
	$pdfDoc = $req->transformPdf($fo);

	echo $pdfDoc;

}else {
	header("Content-Type: text/xml");
	echo $xw->flush();
}
