var precioS, Indice, nuevaFila;
var curentEditingIndex;
var lastServicio = null;
var lastAlmacen = null;
var lastMaterial = null;
var isCustomCascadingCallback = false;
var isCustomCascadingCallback1 = false;

function ValidarOrdenVentaesDetalle(s, e) {
    var grid = ASPxClient.Cast(s);
}
function EscogerTipoPersona(s, e) {
    if (s.GetValue() == 1) {
        lblRucDni.SetText('DNI:');
        lblApelNomRazSoc.SetText('Apell. Nombres:');
        txtRucDni.SetText('');
        txtApelNomRazSoc.SetText('');
    }
    else {
        lblRucDni.SetText('RUC:');
        lblApelNomRazSoc.SetText('Razón Social:');
        txtRucDni.SetText('');
        txtApelNomRazSoc.SetText('');
    }
}
function AccionesBotonBuscarPersona(s, e) {
    //alert(hfIdOrdenVenta.Get('IdOrdenVenta'));
    if (rbOpciones.GetValue() == 2) pcListadoEmpresas.Show();
    else pcListadoClientes.Show();
}
function SeleccionarEmpresa(indice) {
    hfIdCliente.Set("IdPersona", dgEmpresas.batchEditApi.GetCellValue(indice, 'Id'));
    txtRucDni.SetText(dgEmpresas.batchEditApi.GetCellValue(indice, 'RUC'));
    txtApelNomRazSoc.SetText(dgEmpresas.batchEditApi.GetCellValue(indice, 'RazonSocial'));
    pcListadoEmpresas.Hide();
}
function SeleccionarCliente(indice) {
    hfIdCliente.Set("IdPersona", dgClientes.batchEditApi.GetCellValue(indice, 'IdCliente'));
    txtRucDni.SetText(dgClientes.batchEditApi.GetCellValue(indice, 'Dni'));
    txtApelNomRazSoc.SetText(dgClientes.batchEditApi.GetCellValue(indice, 'ApellidoPaterno') + ' ' + dgClientes.batchEditApi.GetCellValue(indice, 'ApellidoMaterno') + ', ' + dgClientes.batchEditApi.GetCellValue(indice, 'Nombres'));
    pcListadoClientes.Hide();
}
var currentColumnName;
function OnBatchEditStartEditing(s, e) {
    currentColumnName = e.focusedColumn.fieldName;
}
function OnBatchEditEndEditing(s, e) {
    window.setTimeout(function () {
        var cantidad, precio, tipoMoneda, precioD;
        precioD = txtPrecioDolar.GetValue();
        cantidad = s.batchEditApi.GetCellValue(e.visibleIndex, "Cantidad", null, true);
        precio = s.batchEditApi.GetCellValue(e.visibleIndex, "Precio", null, true);
        tipoMoneda = s.batchEditApi.GetCellValue(e.visibleIndex, "TipoMoneda", null, true);
        s.batchEditApi.SetCellValue(e.visibleIndex, "Importe", cantidad * precio, null, true);
        if (tipoMoneda == 'Soles') {
            s.batchEditApi.SetCellValue(e.visibleIndex, "Equivalencia", ((cantidad * precio) / precioD).toFixed(4), null, true);
        }
        else if (tipoMoneda == 'Dolares') {
            s.batchEditApi.SetCellValue(e.visibleIndex, "Equivalencia", ((cantidad * precio) * precioD).toFixed(4), null, true);
        }
        else
            s.batchEditApi.SetCellValue(e.visibleIndex, "Equivalencia", 0, null, true);
        seCostoTotal.SetValue(CalcularTotalPagar());
        seSaldoOrden.SetValue(parseFloat(seCostoTotal.GetValue()) - parseFloat(seAdelanto.GetValue()));
    }, 0);
}
function InicioEdicionCD(s, e) {
    Indice = e.visibleIndex;
    if (e.focusedColumn.fieldName == 'Id' || e.focusedColumn.fieldName == 'Importe' || e.focusedColumn.fieldName == 'Equivalencia')
        e.cancel = true;
    if (e.visibleIndex < 0 && nuevaFila == true) {
        s.batchEditApi.SetCellValue(e.visibleIndex, 'TipoMoneda', "Soles");
        s.batchEditApi.SetCellValue(e.visibleIndex, 'Cantidad', "1");
    }
    nuevaFila = false;

    curentEditingIndex = e.visibleIndex;
    var currentServicio = dgOrdenVentaDetalle.batchEditApi.GetCellValue(curentEditingIndex, "IdServicio");
    hf.Set("CurrentServicio", currentServicio);
    if (currentServicio != lastServicio && e.focusedColumn.fieldName == "IdUnidadMedida" && currentServicio != null) {
        lastServicio = currentServicio;
        RefreshData(currentServicio);
    }
}

function CalcularTotalPagar() {
    TotalPagar = 0;
    for (var i = 1; i <= dgOrdenVentaDetalle.GetVisibleRowsOnPage(); i++) {
        //alert(parseFloat(dgServiciosDetalle.batchEditApi.GetCellValue(-i, 'TotalPaciente')));
        if (dgOrdenVentaDetalle.batchEditApi.GetCellValue(-i, 'Importe') != null)
            TotalPagar = (parseFloat(TotalPagar) + parseFloat(dgOrdenVentaDetalle.batchEditApi.GetCellValue(-i, 'Importe'))).toFixed(2);
        else
            TotalPagar = (parseFloat(TotalPagar) + 0).toFixed(4);
    }
    for (var i = 0; i <= dgOrdenVentaDetalle.GetVisibleRowsOnPage(); i++) {
        //alert(parseFloat(dgServiciosDetalle.batchEditApi.GetCellValue(-i, 'TotalPaciente')));
        if (dgOrdenVentaDetalle.batchEditApi.GetCellValue(i, 'Importe') != null)
            TotalPagar = (parseFloat(TotalPagar) + parseFloat(dgOrdenVentaDetalle.batchEditApi.GetCellValue(i, 'Importe'))).toFixed(2);
        else
            TotalPagar = (parseFloat(TotalPagar) + 0).toFixed(4);
    }

    return parseFloat(TotalPagar).toFixed(4);
}

function saldo(s, e) {
    seSaldoOrden.SetValue(parseFloat(seCostoTotal.GetValue()) - parseFloat(seAdelanto.GetValue()));
}

function onInserting(s, e) {
    nuevaFila = true;
}

function ServicioCombo_SelectedIndexChanged(s, e) {
    lastServicio = s.GetValue();
    isCustomCascadingCallback = true;
    cpGetPrecioServ.PerformCallback(s.GetValue());
    RefreshData(lastServicio);
}
function UnidadMedida_EndCallback(s, e) {
    if (isCustomCascadingCallback) {
        if (s.GetItemCount() > 0)
            dgOrdenVentaDetalle.batchEditApi.SetCellValue(curentEditingIndex, "IdUnidadMedida", s.GetItem(0).value);
        isCustomCascadingCallback = false;
    }
}

function RefreshData(servicioValue) {
    hf.Set("CurrentServicio", servicioValue);
    UnidadMedidaEditor.PerformCallback();
}

function TotalPagar(s, e) {
    if (parseFloat(s.GetValue()) > (parseFloat(txtSubTotalTicket.GetValue()) + parseFloat(txtIGV.GetValue()))) {
        LanzarMensaje('El descuento no puede ser mayor al subtotal más el descuento');
        s.SetValue(0);
    } else
        txtTotalTicket.SetValue(((parseFloat(txtSubTotalTicket.GetValue()) + parseFloat(txtIGV.GetValue())) - parseFloat(s.GetValue())).toFixed(2));
}

//NEW CODE MATERIALES - VENTA
function OnBatchEditEndEditingSMD(s, e) {
    window.setTimeout(function () {
        var cantidad, precio, tipoMoneda, precioD;
        //precioD = txtPrecioDolar.GetValue();
        cantidad = s.batchEditApi.GetCellValue(e.visibleIndex, "Cantidad", null, true);
        precio = s.batchEditApi.GetCellValue(e.visibleIndex, "Precio", null, true);
        //tipoMoneda = s.batchEditApi.GetCellValue(e.visibleIndex, "TipoMoneda", null, true);
        s.batchEditApi.SetCellValue(e.visibleIndex, "Importe", cantidad * precio, null, true);
        //if (tipoMoneda == 'Soles') {
        //    s.batchEditApi.SetCellValue(e.visibleIndex, "Equivalencia", ((cantidad * precio) / precioD).toFixed(2), null, true);
        //}
        //else if (tipoMoneda == 'Dolares') {
        //    s.batchEditApi.SetCellValue(e.visibleIndex, "Equivalencia", ((cantidad * precio) * precioD).toFixed(2), null, true);
        //}
        //else
        //    s.batchEditApi.SetCellValue(e.visibleIndex, "Equivalencia", 0, null, true);

        //seCostoTotal.SetValue(CalcularTotalPagar());
        //seSaldoOrden.SetValue(parseFloat(seCostoTotal.GetValue()) - parseFloat(seAdelanto.GetValue()));
    }, 0);
}

function InicioEdicionSMD(s, e) {
    if (hfIdOrdenVenta.Get("IdOrdenVenta") > 0 && e.visibleIndex >= 0) {
        e.cancel = true;
    }
    else {
        Indice = e.visibleIndex;
        if (e.focusedColumn.fieldName == 'Id' || e.focusedColumn.fieldName == 'Importe' || e.focusedColumn.fieldName == 'Equivalencia' || e.focusedColumn.fieldName == 'Stock')
            e.cancel = true;
        if (e.visibleIndex < 0 && nuevaFila == true) {
            dgSalidaMaterialDetalle.batchEditApi.SetCellValue(e.visibleIndex, 'Cantidad', "1");
            dgSalidaMaterialDetalle.batchEditApi.SetCellValue(e.visibleIndex, 'IdAlmacen', "1");
        }
        nuevaFila = false;

        curentEditingIndex = e.visibleIndex;
        var currentAlmacen = dgSalidaMaterialDetalle.batchEditApi.GetCellValue(curentEditingIndex, "IdAlmacen");
        hf.Set("CurrentAlmacen", currentAlmacen);
        if (currentAlmacen != lastAlmacen && e.focusedColumn.fieldName == "IdMaterial" && currentAlmacen != null) {
            lastAlmacen = currentAlmacen;
            RefreshDataM(currentAlmacen, null);
        }
    }
}

function onInserting(s, e) {
    nuevaFila = true;
}

function OnValidationSMD(s, e) {
    var grid = ASPxClientGridView.Cast(s);
    var cellInfo1 = e.validationInfo[grid.GetColumnByField("Cantidad").index];
    var cellInfo2 = e.validationInfo[grid.GetColumnByField("Stock").index];
    var cellInfo3 = e.validationInfo[grid.GetColumnByField("Precio").index];

    if (cellInfo1.value > cellInfo2.value) {
        cellInfo1.isValid = false;
        cellInfo2.isValid = false;
        cellInfo1.errorText = "Error: La cantidad es mayor que las unidades en stock";
        cellInfo2.errorText = "Error: Las unidades en stock es menor que la cantidad";
    } else {
        cellInfo1.isValid = true;
        cellInfo2.isValid = true;
    }

    if (cellInfo3.value <= 0) {
        cellInfo3.isValid = false;
        cellInfo3.errorText = "Error: El precio debe ser mayor a cero";
    } else {
        cellInfo3.isValid = true;
        cellInfo3.errorText = "";
    }
}

function AlmacenCombo_SelectedIndexChanged(s, e) {
    lastAlmacen = s.GetValue();
    isCustomCascadingCallback = true;
    RefreshDataM(lastAlmacen);
}
function Material_EndCallback(s, e) {
    if (isCustomCascadingCallback) {
        if (s.GetItemCount() > 0) {
            dgSalidaMaterialDetalle.batchEditApi.SetCellValue(curentEditingIndex, "IdMaterial", s.GetItem(0).value);
            isCustomCascadingCallback1 = true;
            RefreshDataM(null, s.GetItem(0).value);
            cpGetPrecioMaterial.PerformCallback(dgSalidaMaterialDetalle.batchEditApi.GetCellValue(curentEditingIndex, 'IdMaterial') + '|' + dgSalidaMaterialDetalle.batchEditApi.GetCellValue(curentEditingIndex, 'IdAlmacen'));
        }
        isCustomCascadingCallback = false;
    }
}

function MaterialCombo_SelectedIndexChanged(s, e) {
    lastMaterial = s.GetValue();
    isCustomCascadingCallback1 = true;
    RefreshDataM(null, lastMaterial);
    if (s.GetValue() != null)
        cpGetPrecioMaterial.PerformCallback(s.GetValue() + '|' + dgSalidaMaterialDetalle.batchEditApi.GetCellValue(Indice, 'IdAlmacen'));
}

function UnidadMedidaM_EndCallback(s, e) {
    if (isCustomCascadingCallback1) {
        if (s.GetItemCount() > 0) {
            dgSalidaMaterialDetalle.batchEditApi.SetCellValue(curentEditingIndex, "IdUnidadMedida", s.GetItem(0).value);
        }
        isCustomCascadingCallback1 = false;
    }
}

function RefreshDataM(almacenValue, materialValue) {
    if (almacenValue != null) {
        hf.Set("CurrentAlmacen", almacenValue);
        MaterialEditor.PerformCallback();
    }
    if (materialValue != null) {
        hf1.Set("CurrentMaterial", materialValue);
        UnidadMedidaMEditor.PerformCallback();
    }
}

function NuevaFilaSMD(s, e) {
    if (txtRucDni.GetValue() == null)
        LanzarMensaje('Por favor seleccione un Cliente!');
    else
        dgSalidaMaterialDetalle.AddNewRow();
}

function BotonesOrdenVenta(s, e) {
    if (e.buttonID == 'Editar') e.processOnServer = true;
    if (e.buttonID == 'showReport') {
        if (s.batchEditApi.GetCellValue(e.visibleIndex, 'EstadoOrdenVenta', null, true) != 'Facturada')
            LanzarMensaje('Esta Orden de Venta no Tiene Comprobante');
        else
            e.processOnServer = true;
    }
    if (e.buttonID == 'showProforma') e.processOnServer = true;
    if (e.buttonID == 'btnToOt') e.processOnServer = confirm('Por cada ítem en el detalle de la orden de venta se creará una orden de trabajo: está seguro que desea realizar esta acción?');
    if (e.buttonID == 'Anular') e.processOnServer = confirm('La orden de venta será anulada: está seguro que desea realizar esta acción?');
    if (e.buttonID == 'btnVender') {
        if (s.batchEditApi.GetCellValue(e.visibleIndex, 'TipoOrdenVenta', null, true).indexOf('Trabajo') != -1) {
            if (s.batchEditApi.GetCellValue(e.visibleIndex, 'EstadoOrdenVenta', null, true) == 'Facturada')
                LanzarMensaje('La orden de venta ya ha sido facturada');
            else if (s.batchEditApi.GetCellValue(e.visibleIndex, 'EstadoOrdenVenta', null, true) != 'OrdenTrabajo')
                LanzarMensaje('Únicamente se puede facturar una orden de venta que haya sido convertida a orden de trabajo');
            else {
                pcFacturarOrdenVenta.Show();
                hfIdOV.Set('IdOV', s.batchEditApi.GetCellValue(e.visibleIndex, 'Id', null, true));
                cpEmitirComprobante.PerformCallback(1);
            }
        }
        else {
            if (s.batchEditApi.GetCellValue(e.visibleIndex, 'EstadoOrdenVenta', null, true) == 'Facturada')
                LanzarMensaje('La orden de venta ya ha sido facturada');
            else if (s.batchEditApi.GetCellValue(e.visibleIndex, 'EstadoOrdenVenta', null, true) == 'Anulado')
                LanzarMensaje('La orden de venta ha sido Anulada');
            else {
                pcFacturarOrdenVenta.Show();
                hfIdOV.Set('IdOV', s.batchEditApi.GetCellValue(e.visibleIndex, 'Id', null, true));
                cpEmitirComprobante.PerformCallback(1);
            }
        }

    }
}