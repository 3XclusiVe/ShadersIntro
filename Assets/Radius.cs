
using UnityEngine;

[ExecuteInEditMode]
public class Radius : MonoBehaviour
{
    public Material radiusMaterial; 
    public float radius = 1;
    public Color color = Color.white;
    
    void Update()
    {
        radiusMaterial.SetVector("_CircleCenter", transform.position); 
        radiusMaterial.SetFloat("_CircleRadius", radius); 
        radiusMaterial.SetColor("_CircleColor", color);
    }
}
