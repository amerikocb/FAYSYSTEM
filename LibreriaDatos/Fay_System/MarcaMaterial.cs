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
    
    public partial class MarcaMaterial
    {
        public int Id { get; set; }
        public string Descripcion { get; set; }
        public int IdMaterial { get; set; }
        public int IdEstado { get; set; }
    
        public virtual Estado Estado { get; set; }
        public virtual Material Material { get; set; }
    }
}
