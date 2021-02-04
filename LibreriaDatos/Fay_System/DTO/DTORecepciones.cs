using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LibreriaDatos.DTO
{
    public class DTORecepciones
    {
        public int Id { get; set; }
        public int? IdOrdenCompra { get; set; }
        public DateTime? Fecha { get; set; }
        public int IdProveedor { get; set; }
        public string RazonSocial { get; set; }
        public string Documento { get; set; }
        public string Usuario { get; set; }
        public int? Numero { get; set; }
        public string Serie {get; set;}
        public int? NumeroGuia { get; set; }
        public string SerieGuia { get; set; }
    }
    public class DTORecepcionDetalle : DTORecepciones
    {
        public int IdRecepcionDetalle { get; set; }
        public int? IdOrdenCompraDetalle { get; set; }
        public DateTime? FechaOrdenCD { get; set; }
        public string Proveedor { get; set; }
        public string DocRefOrdenCD { get; set; }
        public string EstadoOrdenCD { get; set; }
        public int IdMaterial { get; set; }
        public string Descripcion { get; set; }
        public int Cantidad { get; set; }
        public int? CantidadRecibida { get; set; }
        public decimal? Precio { get; set; }
        public decimal Importe { get; set; }
        public string UnidadMedida { get; set; }

    }
}
