using UnityEngine;
using System.Collections;

public class clipperScript : MonoBehaviour {

	GameObject pclipper =null;
	MeshRenderer pmr =null;

	// Use this for initialization
	void Start () {
		pmr =GetComponent<MeshRenderer>();
		pmr.material.shader =Resources.Load("NewShader", typeof(Shader)) as Shader;
		pclipper =GameObject.Find("clipper");
	}
	
	// Update is called once per frame
	void Update () {
		pmr.material.SetMatrix("_ClipMatrix", pclipper.transform.worldToLocalMatrix);
		pmr.material.SetFloat("_ClipWidth", 5.0f);
		pmr.material.SetFloat("_ClipHeight", 5.0f);
	}
}
