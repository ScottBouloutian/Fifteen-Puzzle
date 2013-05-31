//
//  Solver.h
//  15 Solver
//
//  Created by Scott Bouloutian on 5/26/13.
//  Copyright (c) 2013 Scott Bouloutian. All rights reserved.
//

#ifndef ___5_Solver__Solver__
#define ___5_Solver__Solver__

#include <iostream>
#include <fstream>

typedef unsigned char byte;

const int FILE_SIZE=524160;
const byte FACTORIAL[4]={1,2,6,24};
const int LOOKUP[120]={0,1,2,4,3,5,6,7,12,18,13,19,8,10,14,20,16,22,9,11,15,21,17,23,24,25,26,28,27,29,48,49,72,96,73,97,50,52,74,98,76,100,51,53,75,99,77,101,30,31,36,42,37,43,54,55,78,102,79,103,60,66,84,108,90,114,61,67,85,109,91,115,32,34,38,44,40,46,56,58,80,104,82,106,62,68,86,110,92,116,64,70,88,112,94,118,33,35,39,45,41,47,57,59,81,105,83,107,63,69,87,111,93,117,65,71,89,113,95,119};

struct Node{
private:
    byte tiles[16];
    byte emptyRow;
    byte emptyCol;
    byte pathCost;
    byte action;
    bool valid=false;
public:
    Node(){
    }
    Node(byte _tiles[16],byte _pathCost,byte _action){
        valid=true;
        for(byte i=0;i<16;i++){
            tiles[i]=_tiles[i];
            if(tiles[i]==0){
                emptyRow=i/4;
                emptyCol=i%4;
            }
        }
        pathCost=_pathCost;
        action=_action;
    }
    bool isNull(){
        return !valid;
    }
    byte* getTiles(){
        return tiles;
    }
    void copyTiles(byte _tiles[16]){
        for(byte i=0;i<16;i++){
            _tiles[i]=tiles[i];
        }
    }
    byte getEmptyRow(){
        return emptyRow;
    }
    byte getEmptyCol(){
        return emptyCol;
    }
    byte getPathCost(){
        return pathCost;
    }
    byte getAction(){
        return action;
    }
    void print(){
        std::cout<<"-----------------------"<<std::endl;
        for(byte i=0;i<16;i++){
            if(i%4==0){
                std::cout<<std::endl;
            }
            std::cout<<(int)tiles[i]<<" ";
        }
        std::cout<<std::endl<<"Path Cost: "<<(int)pathCost<<std::endl;
        std::cout<<"Action Taken: "<<(int)action<<std::endl;
        std::cout<<"-----------------------"<<std::endl;
    }
};

class Solver{
private:
    int exploredNodes;
    char* data1;
    char* data2;
    char* data3;
    short chooseTable[16][16];
    void loadDatabase(std::string&);
    void loadChooseTable();
    int choose(int,int);
    byte heuristic(Node&);
    int calculateIndex(byte[16]);
    byte findPermutation(byte[16]);
    Node depthFirstSearch(Node&,byte);
    bool solved(Node&);
    void possibleMoves(Node&,bool[4]);
    Node swapBlank(Node&,byte);
    byte getChildren(Node&,Node[4]);
    byte inverseOfAction(byte);
public:
    Solver(std::string&);
    ~Solver();
    void solve(Node&);
};

#endif /* defined(___5_Solver__Solver__) */
