//------------------------------------------------------------------------------
// <auto-generated>
//     Este código se generó a partir de una plantilla.
//
//     Los cambios manuales en este archivo pueden causar un comportamiento inesperado de la aplicación.
//     Los cambios manuales en este archivo se sobrescribirán si se regenera el código.
// </auto-generated>
//------------------------------------------------------------------------------

namespace LibreriaDatos.Fay_System
{
    using System;
    using System.Collections.Generic;
    
    public partial class OrdenCompraDetalle
    {
        public int Id { get; set; }
        public int IdOrdenCompra { get; set; }
        public int IdMaterial { get; set; }
        public int Cantidad { get; set; }
        public Nullable<decimal> Precio { get; set; }
        public int IdEstado { get; set; }
        public Nullable<int> IdUnidadMedida { get; set; }
        public string TipoMoneda { get; set; }
        public Nullable<decimal> Equivalencia { get; set; }
        public decimal PrecioDolar { get; set; }
    
        public virtual OrdenCompra OrdenCompra { get; set; }
    }
}
