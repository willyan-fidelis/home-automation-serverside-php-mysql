$(document).ready(function(){
	
	//Define the name space:
	var JSPhpExgData = JSPhpExgData || {};
	
	//Define the constructor of the "Ajax" class
	JSPhpExgData.Ajax = function(_url) {
	  
	  //"Ajax" class defined properties:
	  this.m_url = _url;
	  this.m_AjaxDtRecived = {};
	  this.m_msg = "Initialize!";
	  this.DataRecived = null;
	  this.DataRecivedTestMode = null;
	  //this.deferred = $.Deferred();
	};
	
	/* --- Function Coments ---
	(SendData(_JSONData)) -> Send JSON data from js to Ajax.
	This function used to send Ajax data. After data is sent a promise is invoked(Ajax)
	Parameters: (_JSONData) -> Data to be sent.
	Return: None.
	Promise Return: Ajax promise will return: data recived in JSON format.
	*/
	JSPhpExgData.Ajax.prototype.SendData = function(_JSONData) {
		this.DataRecived = $.ajax({
		data: _JSONData,
		type:'post',
		dataType: 'json',
		url: this.m_url,
		/*
		success: function(_data){
			this.m_AjaxDtRecived = _data;
			console.log(this.m_AjaxDtRecived);
			
			var obj = { nome: "willyan", sobreNome: "fidelis", idade: 28 };
			for (var prop in obj) {
			  console.log("obj." + prop + " = " + obj[prop]);
			}
		}
		*/
	});
	
	//.pipe(function(p){
    //    return "Saved " + JSON.stringify(p);
    //});
	
	return this.DataRecived;
	};
	
	/* --- Function Coments ---
	(SendDataTestMode(_JSONData)) -> Send JSON data from js to Ajax. The data will be recived in string format.
	This function is only to tests purposes.
	Parameters: (_JSONData) -> Data to be send.
	Return: None.
	Primise Return: Ajax promise will return: String(coments + general result + data recived)
	*/
	JSPhpExgData.Ajax.prototype.SendDataTestMode = function(_JSONData) {
		this.DataRecivedTestMode = this.SendData(_JSONData).pipe(function(p){
			return "General Ajax Data Result: " + p.Parameters.OutResult + " Data Recived from Ajaxt to string: " + JSON.stringify(p);
		});
	
	};
	
	
	
	//SendDataTestMode:
	var AjaxDtExg = new JSPhpExgData.Ajax('class/BackToFrontEndDtExg.php');
	AjaxDtExg.SendDataTestMode({ SPName: "SelFromCtm", parm1: "CustomerName", parm2: "Slogan" });
	
	AjaxDtExg.DataRecivedTestMode.done(function(p){
		console.log("ok (AjaxDtExg)");
		console.log(p);
		
	});

	AjaxDtExg.DataRecivedTestMode.fail(function(){
		console.log("error! (AjaxDtExg)");
	});
	
	//SendData:
	var AjaxDtExg2 = new JSPhpExgData.Ajax('class/BackToFrontEndDtExg.php');
	AjaxDtExg2.SendData({ SPName: "SelFromCtm", parm1: "CustomerName", parm2: "Slogan" });
	
	AjaxDtExg2.DataRecived.done(function(p){
		console.log("ok (AjaxDtExg2)");
		console.log(p);
		console.log(p.Parameters.OutResult);
		console.log(p.Results[0].Slogan);
		console.log(p.Results[0].CustomerName);
	});
	
	AjaxDtExg2.DataRecived.fail(function(){
		console.log("error! (AjaxDtExg2)");
	});
	
/*	
var deferred = $.Deferred();

deferred.done(function(value) {
   alert(value);
});

deferred.fail(function(value) {
   alert(value);
});

deferred.resolve("hello world");
deferred.reject("Fail world");
*/		
});