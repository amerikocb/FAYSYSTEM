using System;

namespace LibreriaDatos.Fay_System.DTO
{
    public class DTOComprobantes
    {
        public int Id { get; set; }
        public DateTime Fecha { get; set; }
        public string Serie { get; set; }
        public int Numero { get; set; }
        public string Cliente { get; set; }
        public double Total { get; set; }
        public string Motivo { get; set; }
        public string Observacion { get; set; }
        public string Estado { get; set; }
        public string Usuario { get; set; }
        public int? IdOrdenVenta { get; set; }
        public string NotasCredito { get; set; }

    }
}