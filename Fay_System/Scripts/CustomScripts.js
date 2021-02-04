function ActualizarAlturaGrid(grid) {
    grid.SetHeight(0);
    var alturaContenedor = ASPxClientUtils.GetDocumentClientHeight();
    if (document.body.scrollHeight > alturaContenedor)
        alturaContenedor = document.body.scrollHeight;
    grid.SetHeight(alturaContenedor);
}

function ControlarEnterKey(s, e) {
    if (e.htmlEvent.keyCode == 13) {
        ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
    }
}