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
    
    public partial class Menu
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public Menu()
        {
            this.MenuPerfil = new HashSet<MenuPerfil>();
        }
    
        public int IdMenu { get; set; }
        public bool Habilitado { get; set; }
        public Nullable<int> IdMenuPadre { get; set; }
        public string NombreMenu { get; set; }
        public string DescripcionMenu { get; set; }
        public int Posicion { get; set; }
        public string Url { get; set; }
        public string Icono { get; set; }
        public Nullable<bool> Separador { get; set; }
    
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<MenuPerfil> MenuPerfil { get; set; }
    }
}
