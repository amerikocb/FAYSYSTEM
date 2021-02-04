using LibreriaDatos.DTO;
using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Linq;
using System.Text;
using System.Threading.Tasks;


namespace LibreriaDatos.Fay_System
{
    public class RepMarcaMaterial : Repositorio<MarcaMaterial>
    {
        public RepMarcaMaterial(FayceEntities contexto) : base(contexto)
        {
        }

        public List<MarcaMaterial> ObtenerMarcas_x_Material(int IdMaterial)
        {
            return (from mm in _contexto.MarcaMaterial
                    where mm.IdMaterial == IdMaterial 
                    select mm).ToList();
        }

        public List<MarcaMaterial> ObtenerMarcaMaterial_x_Id(int Id)
        {
            return (from mm in _contexto.MarcaMaterial
                    where mm.Id == Id
                    select mm).ToList();
        }

        public void InsertarValoresMarcaMaterial(OrderedDictionary nuevosValores, int IdMaterial)
        {
            try
            {
                MarcaMaterial um = new MarcaMaterial();
                um.IdMaterial = IdMaterial;
                um.IdEstado = 70;
                LeerNuevosValores(um, nuevosValores);
                using (var db = new UnidadDeTrabajo())
                {
                    
                        if (ObtenerMM_x_Descripcion(um.Descripcion, IdMaterial) == null)
                        {
                            db.MarcaMaterial.Insertar(um);
                            db.Grabar();
                        }
                    }
            }
            catch (Exception)
            {
                return;
            }
        }
        protected void LeerNuevosValores(MarcaMaterial item, OrderedDictionary valores)
        {
            item.Descripcion = valores["Descripcion"].ToString();
            //item.IdEstado = 68;
        }
        public void ActualizarMarcaMaterial(OrderedDictionary keys, OrderedDictionary nuevosValores)
        {
            var id = Convert.ToInt32(keys["Id"]);
            MarcaMaterial um = _contexto.MarcaMaterial.Where(rd => rd.Id == id).FirstOrDefault<MarcaMaterial>();
            LeerNuevosValores(um, nuevosValores);
            um.IdEstado = int.Parse(nuevosValores["IdEstado"].ToString());
            _contexto.SaveChanges();
        }
        public void EliminarMarcaMaterial(OrderedDictionary keys)
        {
            var id = Convert.ToInt32(keys["Id"]);
            MarcaMaterial um = _contexto.MarcaMaterial.Where(rd => rd.Id == id).FirstOrDefault<MarcaMaterial>();
            um.IdEstado = 71;
            _contexto.SaveChanges();
        }

        public MarcaMaterial ObtenerMM_x_Descripcion(string Descripcion, int IdMaterial)
        {
            MarcaMaterial unitM = new MarcaMaterial();
                unitM = _contexto.MarcaMaterial.Where(um => um.Descripcion.ToLower() == Descripcion.ToLower() && um.IdMaterial == IdMaterial).FirstOrDefault<MarcaMaterial>();
            return unitM;
        }

    }
}
