using System.Collections.Generic;
using UnityEngine;

public class DungeonGenerator : MonoBehaviour
{
    public class Room {
        public int x;
        public int y;
        public int width;
        public int height;
        public Room(int x, int y, int width, int height) {
            this.x = x;
            this.y = y;
            this.width = width;
            this.height = height;
        }
    }
    public GameObject floorPrefab;
    public GameObject wallPrefab;

    public int width = 64;
    public int height = 64;

    public int roomMinSize = 6;
    public int roomMaxSize = 12;
    public int maxIterations = 5;

    public List<Room> rooms;
    public List<Room> corridors;

    void Start()
    {
        rooms = new();        
        corridors = new();        

        BSP(maxIterations, new Rect(0, 0, width, height));

        foreach (Room room in rooms) {
            CreateRoom(room);
        }
        foreach (Room corridor in corridors) {
            CreateRoom(corridor);
        }

        BuildWalls();
    }

    void BSP(int iterations, Rect area) {
        if (iterations == 0 || (area.width <= roomMaxSize && area.height <= roomMaxSize)) {
                int roomWidth = UnityEngine.Random.Range(roomMinSize, (int)area.width);
                int roomHeight = UnityEngine.Random.Range(roomMinSize, (int)area.height);
                int roomX = (int)area.x + UnityEngine.Random.Range(0, (int)area.width - roomWidth);
                int roomY = (int)area.y + UnityEngine.Random.Range(0, (int)area.height - roomHeight);

                rooms.Add(new Room(roomX, roomY, roomWidth, roomHeight));
                return;
        }
        float whRatio = area.width / area.height;
        bool splitHorizontally = whRatio switch {
            float ratio when ratio >= 1.25f => false,
            float ratio when ratio <= 0.8f => true,
            _ => UnityEngine.Random.value > 0.5f
        };

        if (splitHorizontally) {
            int split = UnityEngine.Random.Range((int)area.x + roomMinSize, (int)area.xMax - roomMinSize);
            BSP(iterations - 1, new Rect(area.x, area.y, split - area.x, area.height));
            BSP(iterations - 1, new Rect(split, area.y, area.xMax - split, area.height));
            corridors.Add(new Room(split - 1, (int)area.y, 2, (int)area.height));
        } else {
            int split = UnityEngine.Random.Range((int)area.y + roomMinSize, (int)area.yMax - roomMinSize);
            BSP(iterations - 1, new Rect(area.x, area.y, area.width, split - area.y));
            BSP(iterations - 1, new Rect(area.x, split, area.width, area.yMax - split));
            corridors.Add(new Room((int)area.x, split - 1, (int)area.width, 2));
        }
    }

    void CreateRoom(Room room) {
        for (int x = room.x; x < room.x + room.width; ++x)
            for (int y = room.y; y < room.y + room.height; ++y)
                Instantiate(floorPrefab, new UnityEngine.Vector3(x, 0, y), UnityEngine.Quaternion.Euler(90, 0, 0));
    }

    void BuildWalls() {
        List<UnityEngine.Vector3> floorTiles = new();
        UnityEngine.Vector3[] directions = new UnityEngine.Vector3[] {
            new(1, 0, 0),
            new(-1, 0, 0),
            new(0, 0, 1),
            new(0, 0, -1),
        };

        foreach (GameObject floor in GameObject.FindGameObjectsWithTag("Floor")) {
            floorTiles.Add(floor.transform.position);
        }

        foreach (UnityEngine.Vector3 tile in floorTiles) {
            foreach (UnityEngine.Vector3 direction in directions) {
                UnityEngine.Vector3 neigh = tile + direction;
                if (!floorTiles.Contains(neigh)) {
                    Instantiate(wallPrefab, neigh, UnityEngine.Quaternion.identity);
                }
            }
        }
    }
}
