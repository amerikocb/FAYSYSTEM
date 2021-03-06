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
    
    public partial class RequerimientoDetalle
    {
        public int Id { get; set; }
        public int IdRequerimiento { get; set; }
        public int IdMaterial { get; set; }
        public int Cantidad { get; set; }
        public decimal Precio { get; set; }
        public Nullable<decimal> PrecioCompra { get; set; }
        public int IdEstado { get; set; }
        public Nullable<bool> AfectaIGV { get; set; }
        public int IdProveedor { get; set; }
        public string TipoMoneda { get; set; }
        public Nullable<decimal> Equivalencia { get; set; }
        public Nullable<decimal> PrecioDolar { get; set; }
        public int IdUnidadMedida { get; set; }
    
        public virtual Empresa Empresa { get; set; }
        public virtual Material Material { get; set; }
        public virtual Requerimiento Requerimiento { get; set; }
        public virtual UnidadMedida UnidadMedida { get; set; }
    }
}
