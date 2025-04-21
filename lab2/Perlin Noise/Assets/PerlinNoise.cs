using UnityEngine;

public class TerrainDeformer : MonoBehaviour
{
    public float frequency = 0.02f;
    public float heightMultiplier = 5f;
    private Terrain terrain;

    void Start()
    {
        terrain = GetComponent<Terrain>();
        GenerateTerrain();
    }

    void GenerateTerrain()
    {
        TerrainData terrainData = terrain.terrainData;
        int width = terrainData.heightmapResolution;
        int height = terrainData.heightmapResolution;

        float[,] heights = new float[width, height];

        for (int x = 0; x < width; x++)
        {
            for (int y = 0; y < height; y++)
            {
                float xCoord = x * frequency;
                float yCoord = y * frequency;

                float noise = Mathf.PerlinNoise(xCoord, yCoord);
                heights[x, y] = noise * heightMultiplier / terrainData.size.y;
            }
        }

        terrainData.SetHeights(0, 0, heights);
    }
}
