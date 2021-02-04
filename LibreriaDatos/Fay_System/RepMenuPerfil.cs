using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Linq;

namespace LibreriaDatos.Fay_System
{
    public class RepMenuPerfil:Repositorio<MenuPerfil>
    {
        public RepMenuPerfil(FayceEntities contexto) : base(contexto)
        {
        }
        public List<MenuPerfil> ObtenerOpcionesMenu_Por_Usuario(int IdUsuario)
        {
            return _contexto.MenuPerfil.Where(mp => mp.IdUsuario == IdUsuario).ToList();
        }
        public void InsertarValoresMenuPerfil(OrderedDictionary nuevosValores, int IdUsuario)
        {
            try
            {
                MenuPerfil menuPerfil = new MenuPerfil();
                menuPerfil.IdUsuario = IdUsuario;
                LeerNuevosValores(menuPerfil, nuevosValores);
                using (var db = new UnidadDeTrabajo())
                {
                    if (!ObtenerMenuPerfil(menuPerfil))
                    {
                        db.MenuPerfil.Insertar(menuPerfil);
                        db.Grabar();
                    }
                }
            }
            catch(Exception)
            {
                return;
            }
        }
        protected void LeerNuevosValores(MenuPerfil item, OrderedDictionary valores)
        {
            item.IdMenuPadre = Convert.ToInt32(valores["IdMenuPadre"]);
            item.IdEstado = 53;
            item.IdMenuHijo = int.Parse(valores["IdMenuHijo"].ToString());
            if (valores["SoloLectura"] != null)
                item.SoloLectura = bool.Parse(valores["SoloLectura"].ToString());
            else
                item.SoloLectura = false;
        }
        public void ActualizarMenuPerfil(OrderedDictionary keys, OrderedDictionary nuevosValores)
        {
            var id = Convert.ToInt32(keys["IdMenuPerfil"]);
            MenuPerfil menuPerfil = _contexto.MenuPerfil.Where(rd => rd.IdMenuPerfil == id).FirstOrDefault<MenuPerfil>();
            LeerNuevosValores(menuPerfil, nuevosValores);
            _contexto.SaveChanges();
        }
        public void EliminarMenuPerfil(OrderedDictionary keys)
        {
            var id = Convert.ToInt32(keys["IdMenuPerfil"]);
            MenuPerfil menuPerfil = _contexto.MenuPerfil.Where(rd => rd.IdMenuPerfil == id).FirstOrDefault<MenuPerfil>();
            menuPerfil.IdEstado = 54;
            _contexto.SaveChanges();
        }
        public bool ObtenerCombinación_Admitida(string Combinacion)
        {
            return _contexto.MenuPerfil.Where(mp => mp.IdMenuPadre + "" + mp.IdMenuHijo + "" + mp.IdUsuario == Combinacion && mp.IdEstado == 53).Any();
        }

        public bool ObtenerMenuPerfil(MenuPerfil mp)
        {
            return _contexto.MenuPerfil.Any(m => m.IdMenuPadre == mp.IdMenuPadre && m.IdMenuHijo == mp.IdMenuHijo && m.IdUsuario == mp.IdUsuario);
        }
    }
}
