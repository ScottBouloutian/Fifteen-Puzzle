//
//  Solver.cpp
//  15 Solver
//
//  Created by Scott Bouloutian on 5/26/13.
//  Copyright (c) 2013 Scott Bouloutian. All rights reserved.
//

#include "Solver.h"

using namespace std;

Solver::Solver(string& path){
    loadDatabase(path);
    loadChooseTable();
}

void Solver::loadDatabase(string& path){
    string path1=path+"/output1.dat";
    string path2=path+"/output2.dat";
    string path3=path+"/output3.dat";
    ifstream is1 (path1.c_str(), ifstream::binary);
    ifstream is2 (path2.c_str(), ifstream::binary);
    ifstream is3 (path3.c_str(), ifstream::binary);
    if (is1 && is2 && is3) {
        data1 = new char [FILE_SIZE];
        is1.read (data1,FILE_SIZE);
        is1.close();
        data2 = new char [FILE_SIZE];
        is2.read (data2,FILE_SIZE);
        is2.close();
        data3 = new char [FILE_SIZE];
        is3.read (data3,FILE_SIZE);
        is3.close();
    }else{
        //cout<<"Error loading database"<<endl;
    }
}

void Solver::loadChooseTable(){
    for(byte n=0;n<16;n++){
        for(byte r=0;r<16;r++){
            chooseTable[n][r]=choose(n, r);
        }
    }
}

int Solver::choose(int n,int r){
    if(n<r){
        return 0;
    }
    if(r==0 || r==n){
        return 1;
    }
    return choose(n-1,r-1)+choose(n-1,r);
}

Solution Solver::solve(Node* start,int timeLimit){
    this->timeLimit=timeLimit;
    time(&startTime);
    byte nextCostBound=heuristic(start);
    Node* solution=NULL;
    exploredNodes=0;
    while(solution==NULL){
        string path="";
        solution=depthFirstSearch(start, nextCostBound);
        nextCostBound+=2;
    }
    bool isSolved=solved(solution);
    ostringstream ss;
    while(solution->getParent()!=NULL){
        ss<<solution->getAction();
        solution=solution->getParent();
    }
    time(&endTime);
    Solution result(ss.str(),isSolved,difftime(endTime, startTime));
    //cout<<"Solution Found"<<endl;
    return result;
}

byte Solver::heuristic(Node* node){
    byte* tiles=node->getTiles();
    byte pattern1[16];
    byte pattern2[16];
    byte pattern3[16];
    for(byte i=0;i<16;i++){
        pattern1[i]=0;
        pattern2[i]=0;
        pattern3[i]=0;
        switch(tiles[i]){
            case 1:
                pattern1[i]=1;
                break;
            case 2:
                pattern2[i]=1;
                break;
            case 3:
                pattern2[i]=2;
                break;
            case 4:
                pattern2[i]=3;
                break;
            case 5:
                pattern1[i]=2;
                break;
            case 6:
                pattern2[i]=4;
                break;
            case 7:
                pattern2[i]=5;
                break;
            case 8:
                pattern3[i]=1;
                break;
            case 9:
                pattern1[i]=3;
                break;
            case 10:
                pattern1[i]=4;
                break;
            case 11:
                pattern3[i]=2;
                break;
            case 12:
                pattern3[i]=3;
                break;
            case 13:
                pattern1[i]=5;
                break;
            case 14:
                pattern3[i]=4;
                break;
            case 15:
                pattern3[i]=5;
                break;
            default:
                break;
        }
    }
    return data1[calculateIndex(pattern1)]+data2[calculateIndex(pattern2)]+data3[calculateIndex(pattern3)];
}

int Solver::calculateIndex(byte pattern[16]){
    int result=0;
    byte r=1;
    for(byte i=0;i<16;i++){
        if(pattern[i]!=0){
            if(i+1>r){
                result+=chooseTable[i][r];
            }
            r++;
        }
    }
    return result*120+findPermutation(pattern);
}

byte Solver::findPermutation(byte pattern[16]){
    byte p[5];
    byte j=0;
    for(byte i=0;i<16;i++){
        if(pattern[i]!=0){
            p[j]=pattern[i];
            j++;
        }
    }
    byte n=0;
    byte index;
    for(byte i=1;i<5;i++){
        index=0;
        j=0;
        while(p[j]!=i){
            if(p[j]>i){
                index++;
            }
            j++;
        }
        n=n+FACTORIAL[4-i]*index;
    }
    return LOOKUP[n];
}

Node* Solver::depthFirstSearch(Node* current,byte currentCostBound){
    if(solved(current)){
        return current;
    }
    exploredNodes++;
    if(exploredNodes%100000==0){
        //cout<<"explored nodes for this threshold "<<(int)currentCostBound<<" "<<exploredNodes<<endl;
        time(&endTime);
        if(difftime(endTime, startTime)>timeLimit){
            return current;
        }
    }
    Node* children[4];
    byte n=getChildren(current, children);
    for(int i=0;i<n;i++){
        byte value=children[i]->getPathCost()+heuristic(children[i]);
        if(value<=currentCostBound){
            Node *result=depthFirstSearch(children[i], currentCostBound);
            if(result!=NULL){
                return result;
            }
        }
    }
    return NULL;
}

bool Solver::solved(Node* node){
    byte* tiles=node->getTiles();
    for(byte i=0;i<15;i++){
        if(tiles[i]!=i+1){
            return false;
        }
    }
    return true;
}

void Solver::possibleMoves(Node* node,bool possible[4]){
    if(node->getEmptyRow()==0){
        possible[3]=false;
    }
    if(node->getEmptyRow()==3){
        possible[1]=false;
    }
    if(node->getEmptyCol()==0){
        possible[2]=false;
    }
    if(node->getEmptyCol()==3){
        possible[0]=false;
    }
}

Node* Solver::swapBlank(Node* node,byte direction){
    byte tiles[16];
    node->copyTiles(tiles);
    byte temp;
    switch(direction){
        case 3:
            temp=tiles[4*(node->getEmptyRow()-1)+node->getEmptyCol()];
            tiles[4*(node->getEmptyRow()-1)+node->getEmptyCol()]=0;
            tiles[4*node->getEmptyRow()+node->getEmptyCol()]=temp;
            break;
        case 1:
            temp=tiles[4*(node->getEmptyRow()+1)+node->getEmptyCol()];
            tiles[4*(node->getEmptyRow()+1)+node->getEmptyCol()]=0;
            tiles[4*node->getEmptyRow()+node->getEmptyCol()]=temp;
            break;
        case 2:
            temp=tiles[4*node->getEmptyRow()+(node->getEmptyCol()-1)];
            tiles[4*node->getEmptyRow()+(node->getEmptyCol()-1)]=0;
            tiles[4*node->getEmptyRow()+node->getEmptyCol()]=temp;
            break;
        case 0:
            temp=tiles[4*node->getEmptyRow()+(node->getEmptyCol()+1)];
            tiles[4*node->getEmptyRow()+(node->getEmptyCol()+1)]=0;
            tiles[4*node->getEmptyRow()+node->getEmptyCol()]=temp;
            break;
    }
    return new Node(tiles,node->getPathCost()+1,direction,node);
}

byte Solver::getChildren(Node* node,Node* children[4]){
    byte n=0;
    bool possible[4]={true,true,true,true};
    possibleMoves(node, possible);
    for(byte dir=0;dir<4;dir++){
        if(possible[dir] && dir!=inverseOfAction(node->getAction())){
            children[n]=swapBlank(node, dir);
            n++;
        }
    }
    return n;
}

byte Solver::inverseOfAction(byte direction){
    return (direction+2)%4;
}

Solver::~Solver(){
    delete[] data1;
    delete[] data2;
    delete[] data3;
}