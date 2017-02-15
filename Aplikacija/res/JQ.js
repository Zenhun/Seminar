$(function () {
    //u varijablu pospremimo zadnji dio url-a (naziv stranice)
    var pgurl = window.location.href.substr(window.location.href.lastIndexOf("/") + 1);

    //id li elemenata je isti kao i naslov njihoves stranica (npr. id="Seminari.aspx")
    //prođemo sve #nav li elemente i onima kojima id odgovara varijabli pgurl i dodamo klasu active (odabrani link)
    $("#nav li").each(function () {
        if (this.id == pgurl)
            $(this).addClass("active");
    });

    //da nema .stop() dijela fade animacija bi se svaki put odradila do kraja
    //što znači ako brzo uđemo/izađemo s elementa sve te animacije bi se odradile do kraja i nakon što izađemo mišem s elementa
    $("#nav li").hover(function () {
        $(this).stop().animate({ borderColor: "#E3CAC0" }, 150);
    }, function () {
        $(this).stop().animate({ borderColor: "#F7F6F3" }, 250);
    });

    $("#btnPrijavi").hover(function () {
        $(this).stop().addClass("prijaviHover");
        $(this).css('cursor', 'pointer');
    } , function () {
        $(this).stop().removeClass("prijaviHover");
    });


    function fadeElement (element)
    {
        $(element).hover(function () {
            $(this).stop().fadeTo(200, 1);
            $(this).css("cursor", "pointer");
        }, function () {
            $(this).stop().fadeTo(250, 0.6);
        });
    }

    fadeElement("#prijava");
    fadeElement("#natrag");
    fadeElement("#close");
    fadeElement("#closePredavac");

    $("#entryPopupBackground").click(function () {
        $(this).hide("drop", { direction: "up" }, 300);
        $("#entryPopup").hide("drop", { direction: "left" }, 300);
    })

    //u varijable pospremimo podatke iz flex-itema na koji smo kliknuli
    $(".flex-item").click(function () {
        $("#prijaviSeminar").show("drop", 100);
        $("#predbiljezbaDarkScreen").show();
        //spremimo value hidden fielda u varijablu -- nije mi radilo s asp:hiddenfield (?)
        var idSeminara = $(this).find("input:hidden").val();
        //ova kobasica je tu jer ako se napiše samo .text() onda pod Naslov ispisuje i "Prijavi seminar" koji je text child elementa (h2) od .naslov
        var naslov = $(this).find(".naslov").clone().children().remove().end().text();
        var opis = $(this).find(".opis").text();
        var datum = $(this).find("#datum").text();
        var predavac = $(this).find("#predavac").text();
        //zapišemo id odabranog seminara u textbox
        $("#hfPrijavaIdSeminar").val(idSeminara);
        $("#lblPrijavaNaziv").text(naslov);
        $("#lblPrijavaOpis").text(opis);
        $("#lblPrijavaDatum").text(datum);
        $("#lblPrijavaPredavac").text(predavac);

        //izpraznimo textboxove za upis
        $("#txtUnosIme, #txtUnosPrezime, #txtUnosEmail, #txtUnosTel").val("");
    });

    $(".flex-item").hover(function () {
        $(this).find('.overlayWrap, .naslov h2').show();
    }, function() {
        $(this).find('.overlayWrap, .naslov h2').hide();
    })

    $("#close").click(function () {
        $(".update, .popupBackground").hide("drop", 100);
        $("#txtUnosIme, #txtUnosPrezime, #txtUnosEmail, #txtUnosTel, #RequiredFieldValidator1, #RequiredFieldValidator2, #RequiredFieldValidator3, #RegularExpressionValidator1").val("");
        $("#ValidationSummary1").css("display", "none");
    });

    
    //u textarea "Opis seminara" odbrojava broj dopuštenih znakova
    $('#txtOpis').keyup(updateCount);
    $('#txtOpis').keydown(updateCount);

    function updateCount(e) {
        var cs = $(this).val().length;
        if (cs > 345)
        {
            $(this).val($(this).val().substr(0, 345));
        }
        $('#lblOpis').text("Opis (" + (345 - cs).toString() + ")");
    }    
});
