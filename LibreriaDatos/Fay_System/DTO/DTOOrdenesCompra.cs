using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LibreriaDatos.DTO
{
    public class DTOOrdenesCompra
    {
        public int Id { get; set; }
        public DateTime Fecha { get; set; }
        public string RazonSocial { get; set; }
        public string DocumentoReferencia { get; set; }
        public string Usuario { get; set; }
        public string Estado { get; set; }
        public int? NRequerimiento {get; set;}
    }
    public class DTOOrdenCompraDetalle : DTOOrdenesCompra
    {
        public int IdOrdenCD { get; set; }
        public DateTime? FechaOrdenCD { get; set; }
        public string Proveedor { get; set; }
        public string DocRefOrdenCD { get; set; }
        public string EstadoOrdenCD { get; set; }
        public int IdMaterial { get; set; }
        public string Descripcion { get; set; }
        public int? Cantidad { get; set; }
        public decimal? Precio { get; set; }
        public decimal Importe { get; set; }
        public string UnidadMedida { get; set; }

    }
}
