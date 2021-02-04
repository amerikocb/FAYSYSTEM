using LibreriaDatos.DTO;
using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Linq;
using System.Text;
using System.Threading.Tasks;


namespace LibreriaDatos.Fay_System
{
    public class RepUnidadMedida : Repositorio<UnidadMedida>
    {
        public RepUnidadMedida(FayceEntities contexto) : base(contexto)
        {
        }

        public List<UnidadMedida> ObtenerUnidadesMedida_x_Servicio(int IdServicio)
        {
            return (from um in _contexto.UnidadMedida
                    where um.IdServicio == IdServicio && um.IdEstado == 68
                    select um).ToList();
        }

        public List<UnidadMedida> ObtenerUnidadesMedida_x_Material(int IdMaterial)
        {
            return (from um in _contexto.UnidadMedida
                    where um.IdMaterial == IdMaterial && um.IdEstado == 68
                    select um).ToList();
        }

        public List<UnidadMedida> ObtenerUnidadesMedida_x_Id(int Id)
        {
            return (from um in _contexto.UnidadMedida
                    where um.Id == Id
                    select um).ToList();
        }

        public void InsertarValoresUnidadMedida(OrderedDictionary nuevosValores, int? IdServicio, int? IdMaterial)
        {
            try
            {
                UnidadMedida um = new UnidadMedida();
                um.IdServicio = IdServicio;
                um.IdMaterial = IdMaterial;
                um.IdEstado = 68;
                LeerNuevosValores(um, nuevosValores);
                using (var db = new UnidadDeTrabajo())
                {
                    if(IdServicio != null)
                    {
                        if(ObtenerUM_x_Descripcion(um.Descripcion, IdServicio, null) == null)
                        {
                            db.UnidadMedida.Insertar(um);
                            db.Grabar();
                        }
                    }
                    else
                    {
                        if (ObtenerUM_x_Descripcion(um.Descripcion, null, IdMaterial) == null)
                        {
                            db.UnidadMedida.Insertar(um);
                            db.Grabar();
                        }
                    }
                }
            }
            catch (Exception)
            {
                return;
            }
        }
        protected void LeerNuevosValores(UnidadMedida item, OrderedDictionary valores)
        {
            item.Descripcion = valores["Descripcion"].ToString();
            //item.IdEstado = 68;
        }
        public void ActualizarUnidadMedida(OrderedDictionary keys, OrderedDictionary nuevosValores)
        {
            var id = Convert.ToInt32(keys["Id"]);
            UnidadMedida um = _contexto.UnidadMedida.Where(rd => rd.Id == id).FirstOrDefault<UnidadMedida>();
            LeerNuevosValores(um, nuevosValores);
            um.IdEstado = int.Parse(nuevosValores["IdEstado"].ToString());
            _contexto.SaveChanges();
        }
        public void EliminarUnidadMedida(OrderedDictionary keys)
        {
            var id = Convert.ToInt32(keys["Id"]);
            UnidadMedida um = _contexto.UnidadMedida.Where(rd => rd.Id == id).FirstOrDefault<UnidadMedida>();
            um.IdEstado = 69;
            _contexto.SaveChanges();
        }

        public UnidadMedida ObtenerUM_x_Descripcion(string Descripcion, int? IdServicio, int? IdMaterial)
        {
            UnidadMedida unitM = new UnidadMedida();
            if(IdServicio != null)
                unitM =  _contexto.UnidadMedida.Where(um => um.Descripcion.ToLower() == Descripcion.ToLower() && um.IdServicio == IdServicio).FirstOrDefault<UnidadMedida>();
            else
                unitM = _contexto.UnidadMedida.Where(um => um.Descripcion.ToLower() == Descripcion.ToLower() && um.IdMaterial == IdMaterial).FirstOrDefault<UnidadMedida>();
            return unitM;
        }

    }
}
