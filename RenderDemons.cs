using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace DemonRender
{
    public class RenderDemons : MonoBehaviour
    {

        //what mesh should it render
        [SerializeField]
        private Mesh mesh;

        //set the bounds for culling
        [SerializeField]
        private Bounds meshBounds = new Bounds(Vector3.zero, Vector3.one);

        //what material should it render
        [SerializeField]
        private Material material;

        //radius for random positions assigned to the demons
        [SerializeField]
        private float radius = 10f;

        //how many demons
        [SerializeField]
        private int numDemons = 100;

        [SerializeField]
        private float rotationSpeed = 0.1f;

        [SerializeField]
        private float forwardSpeed = 5f;

        private List<Matrix4x4> matrices;
        private MaterialPropertyBlock properties;
        private List<float> rotations;
        private List<float> expressions;

        void Start()
        {
            mesh.bounds = meshBounds;
            matrices = new List<Matrix4x4>();
            properties = new MaterialPropertyBlock();
            rotations = new List<float>();
            expressions = new List<float>();
            for (int i = 0; i < numDemons; i++)
            {
                var posMat = new Matrix4x4();
                posMat.SetTRS(transform.position + Random.insideUnitSphere * radius, Quaternion.identity, Vector3.one);
                matrices.Add(posMat);
                rotations.Add(Random.Range(0f, 1f));
                expressions.Add(Random.Range(0f, 1f));
            }
            properties.SetFloatArray("_Rotation", rotations.ToArray());
            properties.SetFloatArray("_Expression", expressions.ToArray());
        }

        void Update()
        {
            var tranMatrix = new Matrix4x4();
            var moveVector = Vector3.forward * forwardSpeed * Time.deltaTime;
            for (int i = 0; i < rotations.Count; i++)
            {
                rotations[i] += Time.deltaTime * rotationSpeed;
                //tranMatrix.SetTRS(Quaternion.Euler(0,Mathf.Floor(rotations[i]*8f)*42.5f,0) * moveVector, Quaternion.identity, Vector3.one);
                tranMatrix.SetTRS(Quaternion.Euler(0, Mathf.Floor(rotations[i] * 8f) * 45f, 0) * moveVector, Quaternion.identity, Vector3.one);
                matrices[i] *= tranMatrix;
            }
            properties.SetFloatArray("_Rotation", rotations.ToArray());
            Graphics.DrawMeshInstanced(mesh, 0, material, matrices, properties);
        }
    }

}